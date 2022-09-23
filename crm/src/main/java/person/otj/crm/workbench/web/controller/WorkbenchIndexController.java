package person.otj.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import person.otj.crm.commons.contants.Contants;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class WorkbenchIndexController {
    @RequestMapping("/workbench/index.do")
    public String index( HttpSession session, HttpServletRequest request){
        System.out.println("/workbench/index.do : "+session.getAttribute(Contants.SESSION_USER));
        //跳转到业务主页面
        return "workbench/index";
    }
}
