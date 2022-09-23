package person.otj.crm.workbench.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import person.otj.crm.settings.model.User;
import person.otj.crm.settings.service.UserService;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class ActivityController {
    @Autowired
    private UserService userService;
    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request) {
        List<User> users = userService.findAll();
        request.setAttribute("userList",users);
        return "workbench/activity/index";
    }
}
