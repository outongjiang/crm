package person.otj.crm.workbench.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
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
public class customerController {
    @Autowired
    private UserService userService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private CustomerRemarkService customerRemarkService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactsService contactsService;
    @RequestMapping("/workbench/customer/index.do")
    public String index(HttpServletRequest request){
        List<User> userList = userService.findAll();
        request.setAttribute("userList",userList);
        return "workbench/customer/index";

    }


    @ResponseBody
    @RequestMapping("/workbench/customer/savecreateCustomer.do")
    public Object savecreateCustomer(HttpSession session, Customer customer, HttpServletRequest request) {
        ReturnObject returnObject=new ReturnObject();
        //查询该客户名是否已经存在
        String cname = customer.getName();
        if(customerService.isExistName(cname)>0) {
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("客户名已存在....");
            return returnObject;
        }
        customer.setId(UUIDUtils.getUUID());
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        customer.setCreateTime(DateUtils.formateDateTime(new Date()));
        customer.setCreateBy(user.getId());

        try {
            int i = customerService.saveCreateCustomer(customer);
            if(i>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("系统繁忙,请稍后重试.......");
            }
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
        }
        return returnObject;
    }

    //分页功能
    @ResponseBody
    @RequestMapping("/workbench/customer/querycCustomerByConditionForPage.do")
    public Object querycCustomerByConditionForPage( String name, String owner, String website, String phone, int beginNo, int pageSize){
        Map<String ,Object> map=new HashMap<String, Object>();
        System.out.println("----xx--x--x-x-x-xx-x-");
        map.put("name",name);
        map.put("owner",owner);
        map.put("website",website);
        map.put("phone",phone);
        map.put("beginNo",(beginNo-1)*pageSize);
        map.put("pageSize",pageSize);
        System.out.println("map : "+map);
        int totalRows = customerService.queryCountOfCustomerByCondition(map);
        System.out.println(totalRows);
        List<Customer> customerList = customerService.queryCustomerByConditionForPage(map);
        System.out.println(customerList);
        Map<String ,Object>retMap=new HashMap<String, Object>();
        retMap.put("customerList",customerList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }


    //修改回显数据，根据id修改客户
    @ResponseBody
    @RequestMapping("/workbench/customer/updateCustomerById.do")
    public Object updateCustomerById(Customer records){
        System.out.println(records);
        ReturnObject returnObject=new ReturnObject();
        try {
            if(customerService.updateCustomerById(records)>0){
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
        return returnObject;
    }

    //根据id查询客户
    @ResponseBody
    @RequestMapping("/workbench/customer/selectCustomerById.do")
    public Object selectCustomerById(String id){
        Map<String ,Object>reMap=new HashMap<String, Object>();
       Customer customer=customerService.queryCustomerById(id);
        System.out.println(customer);
        reMap.put("owner",customer.getOwner());
        reMap.put("name",customer.getName());
        reMap.put("website",customer.getWebsite());
        reMap.put("phone",customer.getPhone());
        reMap.put("description",customer.getDescription());
        reMap.put("contactSummary",customer.getContactSummary());
        reMap.put("nextContactTime",customer.getNextContactTime());
        reMap.put("address",customer.getAddress());
//        reMap.put("name",activity.getName());
//        reMap.put("start_date",activity.getStartDate());
//        reMap.put("end_date",activity.getEndDate());
//        reMap.put("cost",activity.getCost());
//        reMap.put("description",activity.getDescription());
        System.out.println(reMap);
        return reMap;
    }


//    根据id批量删除 删除包括客户 ，客户备注，客户下的交易，客户下的联系人
    @ResponseBody
    @RequestMapping("/workbench/customer/deleteCustomerByIds.do")
    public Object deleteActivityByIds( String ids[]){
        ReturnObject returnObject=new ReturnObject();
        try {
            customerService.deleteCustomerByIds(ids);

                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("执行成功!");
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
        }
        return returnObject;
    }
    //根据customerId查询客户备注
    @RequestMapping("/workbench/customer/customerDetail.do")
    public String  customerDetail(HttpServletRequest request,String id,HttpSession session){
         User user = (User) session.getAttribute(Contants.SESSION_USER);
         request.setAttribute(Contants.SESSION_USER,user);
        Customer customer = customerService.queryCustomerForDetailById(id);
        List<CustomerRemark> customerRemarkList = customerRemarkService.queryCustomerRemarkListForDetailByCustomerId(id);
        List<Transaction>tranList=transactionService.queryTransactionForCustomerDetailByCustomerId(id);
        List<Contacts>contactList=contactsService.queryContactForCustomerDetailById(id);
        for (Transaction t:tranList) {
            ResourceBundle bundle = ResourceBundle.getBundle("possibility");
            String possibility =  bundle.getString(t.getStage());
            t.setPossibility(possibility);
        }
        List<DictionaryValue> appellation = dicValueService.queryDicValueByCodeType("appellation");
        List<DictionaryValue> sourceList = dicValueService.queryDicValueByCodeType("source");
        List<User> userList = userService.findAll();
        request.setAttribute("customer",customer);
        request.setAttribute("customerRemarkList",customerRemarkList);
        request.setAttribute("tranList",tranList);
        request.setAttribute("appellation",appellation);
        request.setAttribute("sourceList",sourceList);
        request.setAttribute("contactList",contactList);
        request.setAttribute("userList",userList);
        System.out.println(customerRemarkList);
        System.out.println(customer);
        return "workbench/customer/detail";
    }


    //创建保存客户备注
    @ResponseBody
    @RequestMapping("/workbench/customer/saveCreateCustomerRemark.do")
    public Object saveCreateCustomerRemark(HttpSession session,CustomerRemark remark){
        ReturnObject returnObject=new ReturnObject();
        remark.setId(UUIDUtils.getUUID());
        User u=(User)session.getAttribute(Contants.SESSION_USER);
        remark.setCreateBy(u.getId());
        remark.setCreateTime(DateUtils.formateDateTime(new Date()));
        remark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO);
        try {
            if(customerRemarkService.saveCreateCustomerRemark(remark)>0){
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

    //修改客户备注
    @ResponseBody
    @RequestMapping("/workbench/customer/saveEditCustomerRemark.do")
    public Object saveEditCustomerRemark(CustomerRemark remark){
        ReturnObject returnObject=new ReturnObject();
        remark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES);
        remark.setEditTime(DateUtils.formateDateTime(new Date()));
        try{
            int i = customerRemarkService.saveEditCustomerRemark(remark);
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
    //删除客户备注
    @ResponseBody
    @RequestMapping("/workbench/customer/deleteCustomerRemarkById.do")
    public Object deleteCustomerRemarkById(String id){
        ReturnObject returnObject=new ReturnObject();
        System.out.println("xxxxxxxxxxxxxxxxxxxxxxxx"+id);
        try{
            int i = customerRemarkService.deleteCustomerRemarkById(id);
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

    //根据id创建交易
    @RequestMapping("workbench/transaction/saveForCustomerDetail.do")
    public String saveForCustomerDetail(String resource,HttpSession session, HttpServletRequest request,String customerName,String customerId){
        List<DictionaryValue> stageList = dicValueService.queryDicValueByCodeType("stage");
        List<DictionaryValue> transactionTypeList = dicValueService.queryDicValueByCodeType("transactionType");
        List<DictionaryValue> sourceList = dicValueService.queryDicValueByCodeType("source");
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        List<User> userList = userService.findAll();
        request.setAttribute("stageList",stageList);
        request.setAttribute("transactionTypeList",transactionTypeList);
        request.setAttribute("sourceList",sourceList);
        request.setAttribute("userList",userList);
        request.setAttribute("customerName",customerName);
        request.setAttribute("customerId",customerId);
        request.setAttribute("resource",resource);
        return "workbench/transaction/save";
    }
    //客户备注页面删除交易
    @ResponseBody
    @RequestMapping("/workbench/customer/deleteTranForCustomerDetailByTranId.do")
    public Object deleteTranForCustomerDetailByTranId( String id){
        ReturnObject returnObject=new ReturnObject();
        try {
            transactionService.deleteTranForCustomerDetailByTranId(id);
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("执行成功!");
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
        }
        return returnObject;
    }


    //保存创建联系人
    @ResponseBody
    @RequestMapping("/workbench/customer/saveCreateContact.do")
    public Object saveCreateContact(HttpSession session, Contacts contacts){
        ReturnObject returnObject=new ReturnObject();
         User user = (User) session.getAttribute(Contants.SESSION_USER);
        contacts.setId(UUIDUtils.getUUID());
        contacts.setCreateTime(DateUtils.formateDateTime(new Date()));
        contacts.setCreateBy(user.getId());
        returnObject.setRetData(contacts);
        try {
            if(contactsService.saveCreateContact(contacts)>0){
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
        return returnObject;
    }

    //删除联系人


    @ResponseBody
    @RequestMapping("/workbench/customer/deleteContactForCustomerDetailByContactId.do")
    public Object deleteContactForCustomerDetailByContactId(String id){
        ReturnObject returnObject=new ReturnObject();
        try {
            contactsService.deleteContactForCustomerDetailByContactId(id);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setMessage("执行成功!");
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
        }
        return returnObject;
    }



}
