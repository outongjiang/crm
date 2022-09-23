package person.otj.crm.web.controller;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import person.otj.crm.commons.contants.Contants;
import person.otj.crm.settings.model.User;
import javax.servlet.http.HttpSession;
@Controller
public class IndexController {
    @RequestMapping("/")
    public String index(HttpSession session){
        return "index";
    }


}
