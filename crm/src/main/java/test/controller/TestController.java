package test.controller;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import person.otj.crm.settings.model.User;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@Controller
public class TestController {
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
}
