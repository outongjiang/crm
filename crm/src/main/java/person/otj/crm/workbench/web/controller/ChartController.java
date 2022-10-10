package person.otj.crm.workbench.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import person.otj.crm.commons.domain.FunnelVo;
import person.otj.crm.workbench.service.TransactionService;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class ChartController {

    @Autowired
    private TransactionService transactionService;

    @RequestMapping("/workbench/chart/transaction/index.do")
    public String index(){
        return "workbench/chart/transaction/index";
    }


    @RequestMapping("/workbench/chart/transaction/queryCountOfTranGroupByStage.do")
    @ResponseBody
    public Object queryCountOfTranGroupByStage(HttpServletRequest request){
        List<FunnelVo> funnelVoList = transactionService.queryCountOfTranGroupByStage();
        return funnelVoList;
    }
}
