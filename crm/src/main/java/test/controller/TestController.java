package test.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import person.otj.crm.commons.utils.DateUtils;
import person.otj.crm.commons.utils.UUIDUtils;
import person.otj.crm.settings.model.User;
import person.otj.crm.workbench.mapper.ActivitiesMapper;
import person.otj.crm.workbench.model.Activities;
import person.otj.crm.workbench.service.ActivityService;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class TestController {

    @Autowired
    private ActivityService activityService;
    @ResponseBody
    @RequestMapping("/batchInsert")
    public String batchInsert(){
        Activities activities=new Activities();
        activities.setId(UUIDUtils.getUUID());
        activities.setCost("4000");
        activities.setCreateTime(DateUtils.formateDateTime(new Date()));
        activities.setCreateBy("06f5fc056eac41558a964f96daa7f27c");
        activities.setName("活动"+String.valueOf((int)(Math.random()*100)));
        activities.setOwner("40f6cdea0bd34aceb77492a1656d9fb3");
        activities.setDescription("这是活动"+activities.getName()+"的描述");
        activities.setStartDate(DateUtils.formateDateTimeSimple(new Date()));
        Date date=new Date();
        int rnum=(int)(Math.random()*10)-7;
        DateUtils.setMonth(date,date.getMonth()+1+(rnum<0?1:rnum));
        date.setDate((int)(Math.random()*10)*2);
        activities.setEndDate(DateUtils.formateDateTimeSimple(date));
        activityService.saveCreateActivity(activities);
        return "";
    }

    @RequestMapping("/test")
    public String toLogin(){

        return "test/test";
    }

    @RequestMapping("/test2")
    public String test2(HttpSession session, HttpServletResponse response){
        System.out.println(session.getAttribute("role"));
        Cookie cookie=new Cookie("c","c111");
        response.addCookie(cookie);
        return "test/test2";
    }

    @RequestMapping("/test3")
    @ResponseBody
    public String test3(HttpSession session){
        User user =new User();
        user.setName("欧桐江");
        session.setAttribute("role",user);
        return "11";
    }

    @RequestMapping("/test01")
    public String test01(){

        return "test01";
    }


    @RequestMapping("/test02")
    public String test02(){

        return "test02";
    }
}
