package person.otj.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class TypeController {
    @RequestMapping("/settings/dictionary/type/index.do")
    public String index(){
        return "settings/dictionary/type/index";
    }

    @RequestMapping("/settings/dictionary/type/save.do")
    public String save(){
        return "settings/dictionary/type/save";
    }

    @RequestMapping("/settings/dictionary/type/edit.do")
    public String edit(){
        return "settings/dictionary/type/edit";
    }
}
