package person.otj.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class UserController {
    @RequestMapping("/settings/qx/user/toLogin")
    public String toLogin(){
        return "settings/qx/user/login";
    }
}
