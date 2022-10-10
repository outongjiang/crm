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
public class ContactController {

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
    @Autowired
    private ContactsRemarkService contactsRemarkService;
    @Autowired
    private ContactsActivityRelationService contactsActivityRelationService;


    @RequestMapping("/workbench/contacts/index.do")
    public String index(HttpServletRequest request, HttpSession session){
        User user= (User) session.getAttribute(Contants.SESSION_USER);
        List<DictionaryValue> appellation = dicValueService.queryDicValueByCodeType("appellation");
        List<DictionaryValue> sourceList = dicValueService.queryDicValueByCodeType("source");
        List<User> userList = userService.findAll();
        request.setAttribute("appellationList",appellation);
        request.setAttribute("sourceList",sourceList);
        request.setAttribute("userList",userList);
        request.setAttribute(Contants.SESSION_USER,user);
        return "workbench/contacts/index";
    }


    //保存创建联系人
    @ResponseBody
    @RequestMapping("/workbench/contact/saveCreateContact.do")
    public Object saveCreateContact(HttpSession session,Contacts contacts){
        ReturnObject returnObject=new ReturnObject();
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        contacts.setId(UUIDUtils.getUUID());
        contacts.setCreateTime(DateUtils.formateDateTime(new Date()));
        contacts.setCreateBy(user.getId());
        String customerId=customerService.queryIdByName(contacts.getCustomerId());
        contacts.setCustomerId(customerId);
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

    @ResponseBody
    @RequestMapping("/workbench/contact/selectContactById.do")
    public Object selectContactById(String id){
        Map<String ,Object> reMap=new HashMap<String, Object>();
        Contacts contacts = contactsService.queryContactById(id);
        reMap.put("address",contacts.getAddress());
        reMap.put("contactSummary",contacts.getContactSummary());
        reMap.put("customer_id",customerService.queryNameById(contacts.getCustomerId()));
        reMap.put("description",contacts.getDescription());
        reMap.put("owner",contacts.getOwner());
        reMap.put("source",contacts.getSource());
        reMap.put("appellation",contacts.getAppellation());
        reMap.put("job",contacts.getJob());
        reMap.put("mphone",contacts.getMphone());
        reMap.put("email",contacts.getEmail());
        reMap.put("nextContactTime",contacts.getNextContactTime());
        System.out.println(reMap);
        return reMap;
    }

    //分页查询
    @ResponseBody
    @RequestMapping("/workbench/contact/queryContactByConditionForPage.do")
    public Object queryContactByConditionForPage(String owner,String fullname,String source ,String customer_id,int beginNo, int pageSize){
        Map<String ,Object>map=new HashMap<String, Object>();
        System.out.println("----xx--x--x-x-x-xx-x-");
        map.put("owner",owner);
        map.put("fullname",fullname);
        map.put("source",source);
        map.put("customer_id",customer_id);
        map.put("beginNo",(beginNo-1)*pageSize);
        map.put("pageSize",pageSize);
        System.out.println("map : "+map);
        int totalRows = contactsService.queryCountOfContactByCondition(map);
        System.out.println(totalRows);
        List<Contacts>contactsList = contactsService.queryClueByConditionForPage(map);
        Map<String ,Object>retMap=new HashMap<String, Object>();
        retMap.put("contactList",contactsList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }

    //更新联系人信息
    @ResponseBody
    @RequestMapping("/workbench/contact/saveEditContactById.do")
    public Object saveEditContactById(HttpSession session,Contacts contacts){
        ReturnObject returnObject=new ReturnObject();
        returnObject.setRetData(contacts);
        try {
            if(contactsService.saveEditContact(contacts)>0){
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
    //批量删除线索
    @ResponseBody
    @RequestMapping("/workbench/contact/deletecontactByIds.do")
    public Object deletecontactByIds( String ids[]){
        ReturnObject returnObject=new ReturnObject();
        try {
                contactsService.deleteContactByIds(ids);
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("执行成功!");
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
        }
        return returnObject;
    }
    //跳转到联系人明细页面
    //根据customerId查询客户备注
    @RequestMapping("/workbench/contact/detailContact.do")
    public String  detailContact(HttpServletRequest request,String contactId,HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        request.setAttribute(Contants.SESSION_USER,user);
        Contacts contacts=contactsService.queryContactForDetailById(contactId);
        List<ContactsRemark>contactsRemarkList=contactsRemarkService.queryContactsRemarkList(contactId);
//        Customer customer=customerService.queryCustomerById(contacts.getCustomerId());
        List<Transaction>tranList=transactionService.queryTransactionForContactsDetailByContactsId(contactId);
        List<Activities>activityList=activityService.queryActivityForContactsDetailByContactId(contactId);
        for (Transaction t:tranList) {
            ResourceBundle bundle = ResourceBundle.getBundle("possibility");
            String possibility =  bundle.getString(t.getStage());
            t.setPossibility(possibility);
        }
        request.setAttribute("contacts",contacts);
        request.setAttribute("contactsRemarkList",contactsRemarkList);
        request.setAttribute("tranList",tranList);
        request.setAttribute("activityList",activityList);
        System.out.println(contacts);
//        request.setAttribute("customer",customer);
        return "workbench/contacts/detail";
    }

    @ResponseBody
    @RequestMapping("/workbench/contacts/saveCreateContactsRemark.do")
    public Object saveCreateContactsRemark(HttpSession session, ContactsRemark remark){
        ReturnObject returnObject=new ReturnObject();
        remark.setId(UUIDUtils.getUUID());
        User u=(User)session.getAttribute(Contants.SESSION_USER);
        remark.setCreateBy(u.getId());
        remark.setCreateTime(DateUtils.formateDateTime(new Date()));
        remark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO);
        try {
            if(contactsRemarkService.saveCreateContactsRemark(remark)>0){
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


    //删除联系人备注
    @ResponseBody
    @RequestMapping("/workbench/contact/deleteContactRemarkById.do")
    public Object deleteContactRemarkById(String id){
        ReturnObject returnObject=new ReturnObject();
        System.out.println("xxxxxxxxxxxxxxxxxxxxxxxx"+id);
        try{
            int i = contactsRemarkService.deleteContactRemarkById(id);
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

    //修改联系人备注
    @ResponseBody
    @RequestMapping("/workbench/contact/saveEditContactRemark.do")
    public Object saveEditContactRemark(ContactsRemark remark){
        ReturnObject returnObject=new ReturnObject();
        remark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES);
        remark.setEditTime(DateUtils.formateDateTime(new Date()));
        try{
            int i = contactsRemarkService.saveEditContactsRemark(remark);
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
    //联系人备注页面删除交易
    @ResponseBody
    @RequestMapping("/workbench/contacts/deleteTranForContactsDetailByTranId.do")
    public Object deleteTranForContactsDetailByTranId( String id){
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

    @RequestMapping("/workbench/contacts/deleteBund.do")
    @ResponseBody
    public Object deleteBund(String activityId,String contactId){
        System.out.println("dsaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"+activityId);
        ReturnObject returnObject=new ReturnObject();
        Map<String,Object>map=new HashMap<String, Object>();
        map.put("activityId",activityId);
        map.put("contactId",contactId);
        try {
            int i = contactsActivityRelationService.deleteContactsActivityRelationByActivityIdContactsId(map);
            if(i>0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
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



    @RequestMapping("/workbench/contact/queryActivityForDetailByNameContactId.do")
    @ResponseBody
    public Object queryActivityForDetailByNameContactId( String contactId, String name){

        Map<String,Object>map=new HashMap<String, Object>();
        map.put("contactId",contactId);
        map.put("name",name);
        ReturnObject returnObject=new ReturnObject();
        List<Activities> activityList=null;
        try {
            activityList = activityService.queryActivityForDetailByNameContactId(map);
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);

        }catch (Exception e){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
            e.printStackTrace();
        }
        System.out.println(activityList);
        returnObject.setRetData(activityList);
        return activityList;
    }


    @RequestMapping("/workbench/contact/saveBund.do")
    @ResponseBody
    public Object saveBund( String activityId[], String contactId){
        System.out.println("activityId : "+activityId);
        System.out.println("contactId : "+contactId);
        ReturnObject returnObject=new ReturnObject();
        List<ContactsActivityRelation>list=new ArrayList<>();
        for (String a:activityId){
            System.out.println(a);
            ContactsActivityRelation c=new ContactsActivityRelation();
            c.setActivityId(a);
            c.setContactsId(contactId);
            c.setId(UUIDUtils.getUUID());
            list.add(c);

        }
        List<Activities> activityList=null;
        try {
            int i = contactsActivityRelationService.saveCreateContactActivityRelationByList(list);
            activityList = activityService.queryActivityForDetailByIds(activityId);

            if(i>0) {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("系统繁忙,请稍后重试.......");
            }
        }catch (Exception e){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
            e.printStackTrace();
        }
        returnObject.setRetData(activityList);
        return returnObject;
    }
}
