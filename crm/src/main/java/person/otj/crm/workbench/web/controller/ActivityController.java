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
import person.otj.crm.workbench.model.Activities;
import person.otj.crm.workbench.service.ActivityService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ActivityController {

    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

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

}
