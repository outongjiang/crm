package person.otj.crm.workbench.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
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
import java.util.List;

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
}
