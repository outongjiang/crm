package person.otj.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ValueController {
    @RequestMapping("/settings/dictionary/value/index.do")
    public String index(){
        return "settings/dictionary/value/index";
    }

    @RequestMapping("/settings/dictionary/value/save.do")
    public String save(){
        return "settings/dictionary/value/save";
    }

    @RequestMapping("/settings/dictionary/value/edit.do")
    public String edit(){
        return "settings/dictionary/value/edit";
    }
}
