package person.otj.crm.workbench.web.controller;

import com.alibaba.druid.sql.visitor.SQLASTOutputVisitorUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import person.otj.crm.commons.contants.Contants;
import person.otj.crm.commons.domain.ReturnObject;
import person.otj.crm.commons.utils.DateUtils;
import person.otj.crm.commons.utils.UUIDUtils;
import person.otj.crm.settings.model.DictionaryValue;
import person.otj.crm.settings.model.User;
import person.otj.crm.settings.service.DicValueService;
import person.otj.crm.settings.service.UserService;
import person.otj.crm.workbench.model.*;
import person.otj.crm.workbench.service.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class transactionController {
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private UserService userService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private TransactionRemarkService transactionRemarkService;
    @Autowired
    private TransactionHistoryService transactionHistoryService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactsService contactsService;
    @RequestMapping("workbench/transaction/index.do")
    public String index(HttpServletRequest request){
        List<DictionaryValue> stageList = dicValueService.queryDicValueByCodeType("stage");
        List<DictionaryValue> transactionTypeList = dicValueService.queryDicValueByCodeType("transactionType");
        List<DictionaryValue> sourceList = dicValueService.queryDicValueByCodeType("source");

        request.setAttribute("stageList",stageList);
        request.setAttribute("transactionTypeList",transactionTypeList);
        request.setAttribute("sourceList",sourceList);

        return "workbench/transaction/index";
    }

    @RequestMapping("workbench/transaction/save.do")
    public String save(HttpSession session, HttpServletRequest request){
        List<DictionaryValue> stageList = dicValueService.queryDicValueByCodeType("stage");
        List<DictionaryValue> transactionTypeList = dicValueService.queryDicValueByCodeType("transactionType");
        List<DictionaryValue> sourceList = dicValueService.queryDicValueByCodeType("source");
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        List<User> userList = userService.findAll();
        request.setAttribute("stageList",stageList);
        request.setAttribute("transactionTypeList",transactionTypeList);
        request.setAttribute("sourceList",sourceList);
        request.setAttribute("userList",userList);
        return "workbench/transaction/save";
    }

    @RequestMapping("/workbench/transaction/getPossibilityByStage.do")
    @ResponseBody
    public Object getPossibilityByStage(String stageValue){
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility =  bundle.getString(stageValue);
        return possibility;
    }


    @RequestMapping("workbench/customer/queryCustomerName.do")
    @ResponseBody
    public Object queryCustomerName(String customerName){
        System.out.println(customerName);
        return customerService.queryCustomerNameByName(customerName);
    }



    @RequestMapping("workbench/transaction/saveCreateTran.do")
    @ResponseBody
    public Object saveCreateTran(HttpSession session,@RequestParam  Map<String,Object>map){
        System.out.println("dasdadasdasdsadadsadasfdfadasdsadasd : "+map);
        System.out.println(map.get("type"));
        ReturnObject returnObject=new ReturnObject();
         User user = (User) session.getAttribute(Contants.SESSION_USER);
         map.put(Contants.SESSION_USER,user);
        try {
            transactionService.saveCreateTran(map);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
        }
            return returnObject;
    }

    @RequestMapping("workbench/transaction/detail.do")
    public String Todetail(String tranId,HttpServletRequest request){
        System.out.println(tranId);
        Transaction transaction = transactionService.queryTransactionForDetailById(tranId);
        List<TransactionRemark> transactionRemarkList = transactionRemarkService.queryTransactionRemarkListForDetailByTranId(tranId);
        List<TransactionHistory> transactionHistoryList = transactionHistoryService.querytTransactionHistoryListForDetailByTranId(tranId);
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility =  bundle.getString(transaction.getStage());
        List<DictionaryValue> stageList = dicValueService.queryDicValueByCodeType("stage");
        String orderNo = dicValueService.queryStageOrderNoByValue(transaction.getStage());

        request.setAttribute("orderNo",orderNo);
        request.setAttribute("stageList",stageList);
        request.setAttribute("transaction",transaction);
        request.setAttribute("possibility",possibility);
        request.setAttribute("transactionRemarkList",transactionRemarkList);
        request.setAttribute("transactionHistoryList",transactionHistoryList);
        return "workbench/transaction/detail";
    }

    //查询市场活动源
    @RequestMapping("/workbench/transaction/queryActivityForTransactionSaveByName.do")
    @ResponseBody
    public Object queryActivityForTransactionSaveByName(String activityName){
        List<Activities> activityList=null;
        System.out.println(activityName);
        System.out.println(".....................dsaada");
        if(activityName!=null&&!activityName.equals("")){
            activityList = activityService.queryActivityForCustomerDetailByName(activityName);
        }else {
            activityList = activityService.QueryActivityAll();
        }
        System.out.println(activityList);
        return activityList;
    }

    //查询联系人源

    @RequestMapping("/workbench/transaction/queryContactsForTransactionSaveByName.do")
    @ResponseBody
    public Object queryContactsForTransactionSaveByName(String fullname){
        List<Contants> contantsList=null;
        System.out.println(fullname);
        System.out.println(".....................dsaada");
        if(fullname!=null&&!fullname.equals("")){
            contantsList = contactsService.queryContactForTransactionSaveByName(fullname);
        }else {
            contantsList = contactsService.QueryContactAll();
        }
        System.out.println(contantsList);
        return contantsList;
    }


    //保存交易备注

    @ResponseBody
    @RequestMapping("/workbench/transaction/saveCreateTransactionRemark.do")
    public Object saveCreateTransactionRemark(HttpSession session,TransactionRemark remark){
        ReturnObject returnObject=new ReturnObject();
        remark.setId(UUIDUtils.getUUID());
        User u=(User)session.getAttribute(Contants.SESSION_USER);
        remark.setCreateBy(u.getId());
        remark.setCreateTime(DateUtils.formateDateTime(new Date()));
        remark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO);
        try {
            if(transactionRemarkService.saveCreateTranRemark(remark)>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("执行成功!");
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("系统繁忙,请稍后重试.......");
            }
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
        }
        Map<String,Object>retData=new HashMap<String, Object>();
        retData.put("noteContent",remark.getNoteContent());
        retData.put("id",remark.getId());
        retData.put("createTime",remark.getCreateTime());
        returnObject.setRetData(retData);
        return returnObject;
    }

    //修改交易备注
    @ResponseBody
    @RequestMapping("/workbench/transaction/saveEditTranRemark.do")
    public Object saveEditTranRemark(TransactionRemark remark){
        ReturnObject returnObject=new ReturnObject();
        remark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES);
        remark.setEditTime(DateUtils.formateDateTime(new Date()));
        try{
            int i = transactionRemarkService.saveEditCustomerRemark(remark);
            if(i>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);

            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("系统繁忙,请稍后重试.......");
            }
        }catch (Exception e){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
            e.printStackTrace();
        }
        Map<String,Object>map=new HashMap<String, Object>();
        map.put("editTime",remark.getEditTime());
        map.put("noteContent",remark.getNoteContent());
        map.put("id",remark.getId());
        System.out.println("xxxxxxxxxxxxxxxxxxxxxxx"+remark);
        returnObject.setRetData(map);
        return returnObject;
    }
    //删除交易备注
    @ResponseBody
    @RequestMapping("/workbench/transaction/deleteTranRemarkById.do")
    public Object deleteTranRemarkById(String id){
        ReturnObject returnObject=new ReturnObject();
        System.out.println("xxxxxxxxxxxxxxxxxxxxxxxx"+id);
        try{
            int i = transactionRemarkService.deleteTranRemarkById(id);
            if(i>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);

            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("系统繁忙,请稍后重试.......");
            }
        }catch (Exception e){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
            e.printStackTrace();
        }

        return returnObject;
    }


    @RequestMapping("workbench/transaction/selectTransactionById.")
    public String selectTransactionById(HttpServletRequest request,String id){

        return "workbench/transaction/edit";
    }


    //分页功能
    @ResponseBody
    @RequestMapping("/workbench/transaction/querytransactionByConditionForPage.do")
    public Object querycCustomerByConditionForPage(String coustomerId, String source,String contactId, String owner, String name, String type, String stage, int beginNo, int pageSize){
        Map<String ,Object> map=new HashMap<String, Object>();
        System.out.println("----xx--x--x-x-x-xx-x-");
        map.put("contactId",contactId);
        map.put("source",source   );
        map.put("type",type     );
        map.put("stage",stage    );
        map.put("name",name     );
        map.put("owner",owner    );
        map.put("coustomerId",coustomerId    );
        map.put("beginNo",(beginNo-1)*pageSize);
        map.put("pageSize",pageSize);
        System.out.println("map : "+map);
        int totalRows = transactionService.queryCountOfTransactionByCondition(map);
        System.out.println(totalRows);
        List<Transaction> transactionList = transactionService.queryTransactionByConditionForPage(map);
        System.out.println(transactionList);
        Map<String ,Object>retMap=new HashMap<String, Object>();
        retMap.put("transactionList",transactionList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }
    //    根据id批量删除 删除包括交易 ，交易备注，交易历史
    @ResponseBody
    @RequestMapping("/workbench/transaction/deleteTransactionByIds.do")
    public Object deleteTransactionByIds( String ids[]){
        ReturnObject returnObject=new ReturnObject();
        try {
            transactionService.deleteTranByIds(ids);

            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setMessage("执行成功!");
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
        }
        return returnObject;
    }
//    跳转到修改交易页面
    @RequestMapping("/workbench/transaction/selectTransactionById.do")
    public String selectTransactionById( String id,HttpServletRequest request){
        List<User> userList = userService.findAll();
        List<DictionaryValue> stageList = dicValueService.queryDicValueByCodeType("stage");
        List<DictionaryValue> typeList = dicValueService.queryDicValueByCodeType("transactionType");
        List<DictionaryValue> sourceList = dicValueService.queryDicValueByCodeType("source");
        Transaction transaction=transactionService.queryTransactionForEditById(id);
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        for (DictionaryValue stage:stageList) {
            stage.setPossibility(bundle.getString(stage.getValue()));
        }
        request.setAttribute("userList",userList);
        request.setAttribute("stageList",stageList);
        request.setAttribute("typeList",typeList);
        request.setAttribute("sourceList",sourceList);
        transaction.setPossibility(bundle.getString(transaction.getStageName()));
        request.setAttribute("transaction",transaction);
        return "workbench/transaction/edit";
    }

    //保存修改交易并跳转到交易index页面


    @ResponseBody
    @RequestMapping("/workbench/transaction/saveEditTran.do")
    public Object saveEditTran(HttpSession session,Transaction transaction) throws InterruptedException {
        ReturnObject returnObject=new ReturnObject();
         User user= (User) session.getAttribute(Contants.SESSION_USER);
        transaction.setEditBy(user.getId());
        transaction.setEditTime(DateUtils.formateDateTime(new Date()));
        String customerName = transaction.getCustomerId();
        String customerId = customerService.queryIdByName(customerName);
        transaction.setCustomerId(customerId);
        System.out.println(transaction);
        try{
            int i = transactionService.saveEditTran(transaction);
            if(i>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);

            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("系统繁忙,请稍后重试.......");
            }
        }catch (Exception e){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
            e.printStackTrace();
        }
        return returnObject;
    }
}
