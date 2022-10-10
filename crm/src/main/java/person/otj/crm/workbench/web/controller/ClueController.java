package person.otj.crm.workbench.web.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import person.otj.crm.commons.contants.Contants;
import person.otj.crm.commons.domain.ReturnObject;

import person.otj.crm.commons.utils.DateUtils;
import person.otj.crm.commons.utils.UUIDUtils;
import person.otj.crm.settings.model.User;
import person.otj.crm.settings.service.UserService;
import person.otj.crm.settings.model.DictionaryValue;
import person.otj.crm.settings.service.DicValueService;
import person.otj.crm.workbench.model.*;
import person.otj.crm.workbench.service.ActivityService;
import person.otj.crm.workbench.service.ClueActivityRelationService;
import person.otj.crm.workbench.service.ClueRemarkService;
import person.otj.crm.workbench.service.ClueService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ClueController {
    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request){
        List<User> userList = userService.findAll();
        List<DictionaryValue>appellationList=dicValueService.queryDicValueByCodeType("appellation");
        List<DictionaryValue>clueStateList=dicValueService.queryDicValueByCodeType("clueState");
        List<DictionaryValue>sourceList=dicValueService.queryDicValueByCodeType("source");
        request.setAttribute("userList",userList);
        request.setAttribute("appellationList",appellationList);
        request.setAttribute("clueStateList",clueStateList);
        request.setAttribute("sourceList",sourceList);
        return "workbench/clue/index";
    }

    @RequestMapping("/workbench/clue/saveCreateClue.do")
    @ResponseBody
    public Object saveCreateClue(HttpSession session,Clue clue, HttpServletRequest request){
        User user= (User) session.getAttribute(Contants.SESSION_USER);
            ReturnObject returnObject=new ReturnObject();
            clue.setId(UUIDUtils.getUUID());
            clue.setCreateTime(DateUtils.formateDateTime(new Date()));
            clue.setCreateBy(user.getId());
            System.out.println("sdasdadsadas : "+clue);
            try{
                int i=clueService.saveCreateClue(clue);
                if(i>0){
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                }else {
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                    returnObject.setMessage("系统繁忙,请稍后重试.......");
                }
            }catch (Exception e){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("系统繁忙,请稍后重试.......");
            }
            return returnObject;
    }

    @RequestMapping("/workbench/clue/detailClue.do")
    public String detailClue(String clueId,HttpServletRequest request){
        Clue clue = clueService.queryClueForDetailById(clueId);
        List<ClueRemark> RemarkList = clueRemarkService.queryClueRemarkForDetailByClueId(clueId);
        List<Activities> activityList = activityService.queryActivityForDetailByClueId(clueId);
        request.setAttribute("clue",clue);
        request.setAttribute("RemarkList",RemarkList);
        request.setAttribute("activityList",activityList);
        return "workbench/clue/detail";
    }

    @RequestMapping("/workbench/clue/queryActivityForDetailByNameClueId.do")
    @ResponseBody
    public Object queryActivityForDetailByNameClueId( String clueId, String name){
        System.out.println("dadasda : "+clueId);
        System.out.println("d sad ad : "+name);
        Map<String,Object>map=new HashMap<String, Object>();
        map.put("clueId",clueId);
        map.put("name",name);
        ReturnObject returnObject=new ReturnObject();
        List<Activities> activityList=null;
        try {
            activityList = activityService.queryActivityForDetailByNameClueId(map);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);

        }catch (Exception e){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
            e.printStackTrace();
        }
        System.out.println(activityList);
        returnObject.setRetData(activityList);
        return activityList;
    }
    @RequestMapping("/workbench/clue/saveBund.do")
    @ResponseBody
    public Object saveBund( String activityId[], String clueId){
        System.out.println("activityId : "+activityId);
        System.out.println("clueId : "+clueId);
        ReturnObject returnObject=new ReturnObject();
        List<ClueActivityRelation>list=new ArrayList<ClueActivityRelation>();
        for (String a:activityId){
            System.out.println(a);
            ClueActivityRelation c=new ClueActivityRelation();
            c.setActivityId(a);
            c.setClueId(clueId);
            c.setId(UUIDUtils.getUUID());
            list.add(c);

        }
        List<Activities> activityList=null;
        try {
            int i = clueActivityRelationService.saveCreateClueActivityRelationByList(list);
            activityList = activityService.queryActivityForDetailByIds(activityId);

            if(i>0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("系统繁忙,请稍后重试.......");
            }
        }catch (Exception e){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
            e.printStackTrace();
        }
        returnObject.setRetData(activityList);
        return returnObject;
    }



    @RequestMapping("/workbench/clue/deleteBund.do")
    @ResponseBody
    public Object deleteBund(String activityId,String clueId){
        System.out.println("dsaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"+activityId);
        ReturnObject returnObject=new ReturnObject();
        Map<String,Object>map=new HashMap<String, Object>();
        map.put("activityId",activityId);
        map.put("clueId",clueId);
        try {
            int i = clueActivityRelationService.deleteClueActivityRelationByActivityIdClueId(map);
            if(i>0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
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

    @RequestMapping("/workbench/clue/convert.do")
    public String toConvert(HttpServletRequest request,String clueId){
        Clue clue = clueService.queryClueForDetailById(clueId);
        List<DictionaryValue> stageList = dicValueService.queryDicValueByCodeType("stage");
        request.setAttribute("clue",clue);
        request.setAttribute("stageList",stageList);
        return "workbench/clue/convert";
    }

    @RequestMapping("/workbench/clue/queryActivityForConvertByNameClueId.do")
    @ResponseBody
    public Object queryActivityForConvertByNameClueId(String activityName,String clueId){

        Map<String,Object>map=new HashMap<String, Object>();
        map.put("activityName",activityName);
        map.put("clueId",clueId);
        List<Activities> activityList = activityService.queryActivityForConvertByNameClueId(map);
        return activityList;
    }


    @RequestMapping("/workbench/clue/convertClue.do")
    @ResponseBody
    public Object convertClue(HttpSession session,String clueId,String money,String name,String expectedDate,String stage,String activityId,String isCreateTran ){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        Map<String,Object>map=new HashMap<String, Object>();
        map.put("clueId",clueId);
        map.put("money",money);
        map.put("name",name);
        map.put("expectedDate",expectedDate);
        map.put("stage",stage);
        map.put("activityId",activityId);
        map.put("isCreateTran",isCreateTran);
        System.out.println("fdwaefwafffffffffffffffffffffffffffffffffffffff+"+(String)map.get("isCreateTran"));
        map.put(Contants.SESSION_USER,user);
        ReturnObject returnObject=new ReturnObject();
        try {
            clueService.saveConvertClue(map);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
            e.printStackTrace();
        }
        return returnObject;
    }

    @ResponseBody
    @RequestMapping("/workbench/clue/saveCreateClueRemark.do")
    public Object saveCreateClueRemark(HttpSession session, ClueRemark remark){
        ReturnObject returnObject=new ReturnObject();
        remark.setId(UUIDUtils.getUUID());
        User u=(User)session.getAttribute(Contants.SESSION_USER);
        remark.setCreateBy(u.getId());
        remark.setCreateTime(DateUtils.formateDateTime(new Date()));
        remark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO);
        try {
            if(clueRemarkService.saveCreateClueRemark(remark)>0){
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


    //分页查询
    @ResponseBody
    @RequestMapping("/workbench/clue/queryClueByConditionForPage.do")
    public Object queryClueByConditionForPage(String select_fullname,String select_company,String select_mphone,String select_source,String select_owner,String select_phone,String select_state, int beginNo, int pageSize){
        Map<String ,Object>map=new HashMap<String, Object>();
        System.out.println("----xx--x--x-x-x-xx-x-");
        map.put("select_state",select_state);
        map.put("select_phone",select_phone);
        map.put("select_owner",select_owner);
        map.put("select_source",select_source);
        map.put("select_mphone",select_mphone);
        map.put("select_company",select_company);
        map.put("select_fullname",select_fullname);
        map.put("beginNo",(beginNo-1)*pageSize);
        map.put("pageSize",pageSize);
        System.out.println("map : "+map);
       int totalRows = clueService.queryCountOfClueByCondition(map);
        System.out.println(totalRows);
        List<Clue> clueList = clueService.queryClueByConditionForPage(map);
        System.out.println(clueList);
        Map<String ,Object>retMap=new HashMap<String, Object>();
        retMap.put("clueList",clueList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }


    @ResponseBody
    @RequestMapping("/workbench/clue/selectClueById.do")
    public Object selectClueById(String id){
        Map<String ,Object>reMap=new HashMap<String, Object>();
        Clue clue = clueService.queryClueById(id);

        reMap.put("owner",clue.getOwner());
        reMap.put("company",clue.getCompany());
        reMap.put("appellation",clue.getAppellation());
        reMap.put("fullname",clue.getFullname());
        reMap.put("job",clue.getJob());
        reMap.put("email",clue.getEmail());
        reMap.put("mphone",clue.getMphone());
        reMap.put("website",clue.getWebsite());
        reMap.put("phone",clue.getPhone());
        reMap.put("state",clue.getState());
        reMap.put("source",clue.getSource());
        reMap.put("description",clue.getDescription());
        reMap.put("contactSummary",clue.getContactSummary());
        reMap.put("nextContactTime",clue.getNextContactTime());
        reMap.put("address",clue.getAddress());
        System.out.println(reMap);
        return reMap;
    }



    @ResponseBody
    @RequestMapping("/workbench/clue/updateClueById.do")
    public Object updateClueById(Clue clue,HttpSession session){
        ReturnObject returnObject=new ReturnObject();
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        clue.setEditBy(user.getId());
        clue.setEditTime(DateUtils.formateDateTime(new Date()));
        System.out.println("workbench/clue/updateClueById.do");
        try {
            if(clueService.updateClueById(clue)>0){
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
    //批量删除线索
    @ResponseBody
    @RequestMapping("/workbench/clue/deleteClueByIds.do")
    public Object deleteClueByIds( String ids[]){
        ReturnObject returnObject=new ReturnObject();
        try {
            if(clueService.deleteClueByIds(ids)>0){
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

    //删除线索备注
    @ResponseBody
    @RequestMapping("/workbench/clue/deleteClueRemarkById.do")
    public Object deleteClueRemarkById(String id){
        ReturnObject returnObject=new ReturnObject();
        System.out.println("xxxxxxxxxxxxxxxxxxxxxxxx"+id);
        try{
            int i = clueRemarkService.deleteClueRemarkById(id);
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

    //修改线索备注
    @ResponseBody
    @RequestMapping("/workbench/clue/saveEditClueRemark.do")
    public Object saveEditClueRemark(ClueRemark remark){
        ReturnObject returnObject=new ReturnObject();
        remark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES);
        remark.setEditTime(DateUtils.formateDateTime(new Date()));
        try{
            int i = clueRemarkService.saveEditClueRemark(remark);
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


