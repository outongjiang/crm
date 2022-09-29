package person.otj.crm.workbench.web.controller;
import org.apache.poi.hssf.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import person.otj.crm.commons.contants.Contants;
import person.otj.crm.commons.domain.ReturnObject;
import person.otj.crm.commons.utils.*;
import person.otj.crm.settings.model.User;
import person.otj.crm.settings.service.UserService;
import person.otj.crm.workbench.model.Activities;
import person.otj.crm.workbench.model.ActivitiesRemark;
import person.otj.crm.workbench.service.ActivityRemarkService;
import person.otj.crm.workbench.service.ActivityService;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;

@Controller
public class ActivityController {

    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ActivityRemarkService activityRemarkService;


    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request) {
        List<User> users = userService.findAll();
        request.setAttribute("userList",users);
        return "workbench/activity/index";
    }

    @ResponseBody
    @RequestMapping("/workbench/activity/savecreateActivity.do")
    public Object savecreateActivity(HttpSession session, Activities activity, HttpServletRequest request) {
        activity.setId(UUIDUtils.getUUID());
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        activity.setCreateTime(DateUtils.formateDateTime(new Date()));
        activity.setCreateBy(user.getId());
        ReturnObject returnObject=new ReturnObject();
        try {
            int i = activityService.saveCreateActivity(activity);
            if(i>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("系统繁忙,请稍后重试.......");
            }
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
        }
        return returnObject;
    }
    @ResponseBody
    @RequestMapping("/workbench/activity/querycActivityByConditionForPage.do")
    public Object querycActivityByConditionForPage( String param_name, String param_owner, String param_start_date, String param_end_date, int beginNo, int pageSize){
        Map<String ,Object>map=new HashMap<String, Object>();
        System.out.println("----xx--x--x-x-x-xx-x-");
        map.put("param_name",param_name);
        map.put("param_owner",param_owner);
        map.put("param_start_date",param_start_date);
        map.put("param_end_date",param_end_date);
        map.put("beginNo",(beginNo-1)*pageSize);
        map.put("pageSize",pageSize);
        System.out.println("map : "+map);
        int totalRows = activityService.queryCountOfActivityByCondition(map);
        System.out.println(totalRows);
        List<Activities> activityList = activityService.querycActivityByConditionForPage(map);
        System.out.println(activityList);
        Map<String ,Object>retMap=new HashMap<String, Object>();
        retMap.put("activityList",activityList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }

    @ResponseBody
    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    public Object deleteActivityByIds( String ids[]){
        ReturnObject returnObject=new ReturnObject();
        try {
            if(activityService.deleteActivityByIds(ids)>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("执行成功!");
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("系统繁忙,请稍后重试.......");
            }
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
        }
        return returnObject;
    }


    @ResponseBody
    @RequestMapping("/workbench/activity/updateActivityById.do")
    public Object updateActivityById(Activities records){
        System.out.println(records);
        ReturnObject returnObject=new ReturnObject();
        try {
            if(activityService.updateActivityById(records)>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("执行成功!");
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("系统繁忙,请稍后重试.......");
            }
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
        }
        return returnObject;
    }
    @ResponseBody
    @RequestMapping("/workbench/activity/selectActivityById.do")
    public Object selectActivityById(String id){
        Map<String ,Object>reMap=new HashMap<String, Object>();
        Activities activity = activityService.queryActivityById(id);
        System.out.println(activity);
        reMap.put("owner",activity.getOwner());
        reMap.put("name",activity.getName());
        reMap.put("start_date",activity.getStartDate());
        reMap.put("end_date",activity.getEndDate());
        reMap.put("cost",activity.getCost());
        reMap.put("description",activity.getDescription());
        System.out.println(reMap);
        return reMap;
    }


    @RequestMapping("workbench/activity/fileDownload.do")
    public void fileDownload(HttpServletResponse response) throws IOException {
        //设置下载文件类型
        response.setContentType("application/x-xls;charset=UTF-8");
        OutputStream out=response.getOutputStream();
        //设置下载文件弹窗
        response.setHeader("Content-Disposition","attachment;filename=mystudentList.xls");
        //获取文件输入流
        InputStream inputStream=new FileInputStream("D:\\wb\\StudentList.xls");
        //设置缓冲区
        byte buff[]=new byte[1024*1000];

        int len=0;
        //将输入流的文件读到缓冲区
        while ((len=inputStream.read(buff))!=-1){
            //将缓冲区的文件写到输出流
            out.write(buff,0,len);
        }


        inputStream.close();
        out.flush();

    }


    @RequestMapping("workbench/activity/exportAllActivity.do")
    public void exportAllActivity(HttpServletRequest request,HttpServletResponse response) throws IOException {

        List<Activities> activities = activityService.QueryActivityAll();

        HSSFWorkbook wb=new HSSFWorkbook();

        HSSFWorkbookUtils.getHSSFWorkbook(wb,activities);

        String path=request.getServletContext().getRealPath("/")+"activityList.xls";

//        wb.write(new File(path));

        //设置下载文件类型
        response.setContentType("application/x-xls;charset=UTF-8");
        OutputStream out=response.getOutputStream();
        wb.write(out);
        //设置下载文件弹窗
        response.setHeader("Content-Disposition","attachment;filename=activityList.xls");
        //获取文件输入流
        InputStream inputStream=new FileInputStream(path);
        //设置缓冲区
        byte buff[]=new byte[1024*1000];

        int len=0;
        //将输入流的文件读到缓冲区
        while ((len=inputStream.read(buff))!=-1){
            //将缓冲区的文件写到输出流
            out.write(buff,0,len);
        }


        inputStream.close();
        out.flush();
        wb.close();

    }



    @RequestMapping("workbench/activity/QueryActivityByIds.do")
    public void QueryActivityByIds(String ids[],HttpServletRequest request,HttpServletResponse response) throws IOException {

        List<Activities> activities = activityService.QueryActivityByIds(ids);
        System.out.println(activities);
        HSSFWorkbook wb=new HSSFWorkbook();

        HSSFWorkbookUtils.getHSSFWorkbook(wb,activities);

        String path=request.getServletContext().getRealPath("/")+"activityList.xls";

//        wb.write(new File(path));

        //设置下载文件类型
        response.setContentType("application/x-xls;charset=UTF-8");
        OutputStream out=response.getOutputStream();
        wb.write(out);
        //设置下载文件弹窗
        response.setHeader("Content-Disposition","attachment;filename=activityList.xls");
        //获取文件输入流
        InputStream inputStream=new FileInputStream(path);
        //设置缓冲区
        byte buff[]=new byte[1024*1000];

        int len=0;
        //将输入流的文件读到缓冲区
        while ((len=inputStream.read(buff))!=-1){
            //将缓冲区的文件写到输出流
            out.write(buff,0,len);
        }

        ResourceUtils.resourceClose(inputStream,out,wb);
//        inputStream.close();
//        out.flush();
//        wb.close();

    }

    @ResponseBody
    @RequestMapping("/workbench/activity/fileUpload.do")
    public Object fileUpload(HttpSession session,MultipartFile myfile,String filename) throws IOException {
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        System.out.println(filename);

        InputStream inputStream = myfile.getInputStream();

        HSSFWorkbook wb=new HSSFWorkbook(inputStream);

        System.out.println(wb.getSheetAt(0).getRow(1).getCell(2));

        HSSFSheet sheet = wb.getSheetAt(0);

        HSSFRow row=null;

        Activities activity=null;

        ReturnObject returnObject=new ReturnObject();

        returnObject.setRetData(sheet.getLastRowNum());
        List<Activities>activities=new ArrayList<Activities>();
      
            for (int i = 1; i <=sheet.getLastRowNum(); i++) {
                row = sheet.getRow(i);
                activity = new Activities();
                activity.setName(String.valueOf(row.getCell(0)));
                activity.setOwner(String.valueOf(row.getCell(1)));
                activity.setStartDate(String.valueOf(row.getCell(2)));
                activity.setEndDate(String.valueOf(row.getCell(3)));
                activity.setId(UUIDUtils.getUUID());
                activity.setOwner(user.getId());
                activity.setCreateBy(user.getId());
                activity.setCreateTime(DateUtils.formateDateTime(new Date()));
                System.out.println(activity);
                activities.add(activity);
            }
        try {
            if(activityService.saveCreateActivityList(activities)>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("执行成功!");
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("系统繁忙,请稍后重试.......");
            }
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
        }
                return returnObject;
    }



    @RequestMapping("/workbench/activity/activityDetail.do")
    public String  activityDetail(HttpServletRequest request,String id){
        Activities activity = activityService.queryActivityById(id);
        List<ActivitiesRemark> activitiesRemarksList = activityRemarkService.queryActivityRemarkForDetailByActivityId(id);
        request.setAttribute("activity",activity);
        request.setAttribute("activitiesRemarksList",activitiesRemarksList);
        System.out.println(activitiesRemarksList);
        System.out.println(activity);
        return "workbench/activity/detail";
    }


    @ResponseBody
    @RequestMapping("/workbench/activity/saveCreateActivityRemark.do")
    public Object saveCreateActivityRemark(HttpSession session,ActivitiesRemark remark){
        ReturnObject returnObject=new ReturnObject();
        remark.setId(UUIDUtils.getUUID());
        User u=(User)session.getAttribute(Contants.SESSION_USER);
        remark.setCreateBy(u.getId());
        remark.setCreateTime(DateUtils.formateDateTime(new Date()));
        remark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO);
        try {
            if(activityRemarkService.saveCreateActivityRemark(remark)>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("执行成功!");
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("系统繁忙,请稍后重试.......");
            }
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
        }
        Map<String,Object>retData=new HashMap<String, Object>();
        retData.put("noteContent",remark.getNoteContent());
        retData.put("id",remark.getId());
        retData.put("createTime",remark.getCreateTime());
        returnObject.setRetData(retData);
        return returnObject;
    }


    @ResponseBody
    @RequestMapping("/workbench/activity/deleteActivityRemarkById.do")
    public Object deleteActivityRemarkById(String id){
        ReturnObject returnObject=new ReturnObject();
        System.out.println("xxxxxxxxxxxxxxxxxxxxxxxx"+id);
        try{
            int i = activityRemarkService.deleteActivityRemarkById(id);
            if(i>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);

            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("系统繁忙,请稍后重试.......");
            }
        }catch (Exception e){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
            e.printStackTrace();
        }

        return returnObject;
    }




    @ResponseBody
    @RequestMapping("/workbench/activity/saveEditActivityRemark.do")
    public Object saveEditActivityRemark(ActivitiesRemark remark){
        ReturnObject returnObject=new ReturnObject();
        remark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES);
        remark.setEditTime(DateUtils.formateDateTime(new Date()));
        try{
            int i = activityRemarkService.saveEditActivityRemark(remark);
            if(i>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);

            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("系统繁忙,请稍后重试.......");
            }
        }catch (Exception e){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
            e.printStackTrace();
        }
        Map<String,Object>map=new HashMap<String, Object>();
        map.put("editTime",remark.getEditTime());
        map.put("noteContent",remark.getNoteContent());
        map.put("id",remark.getId());
        System.out.println("xxxxxxxxxxxxxxxxxxxxxxx"+remark);
        returnObject.setRetData(map);
        return returnObject;
    }
}
