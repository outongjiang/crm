package person.otj.crm.workbench.service.impl;

import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import person.otj.crm.commons.contants.Contants;
import person.otj.crm.commons.utils.DateUtils;
import person.otj.crm.commons.utils.UUIDUtils;
import person.otj.crm.settings.model.User;
import person.otj.crm.workbench.mapper.*;
import person.otj.crm.workbench.model.*;
import person.otj.crm.workbench.service.ClueRemarkService;
import person.otj.crm.workbench.service.ClueService;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueMapper clueMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    public Clue queryClueForDetailById(String id) {
        return clueMapper.selectClueForDetailById(id);
    }

    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    public void saveConvertClue(Map<String, Object> map) {
        String clueId  = (String) map.get("clueId");
        User user = (User) map.get(Contants.SESSION_USER);
        String createTime=DateUtils.formateDateTime(new Date());
        String isCreateTran = (String) map.get("isCreateTran");

        Clue clue=clueMapper.selectClueById(clueId);
        //拷贝一份线索表数据给客户表
        Customer customer=new Customer();
        customer.setAddress(clue.getAddress());
        customer.setCreateTime(createTime);
        customer.setCreateBy(user.getId());
        customer.setContactSummary(clue.getContactSummary());
        customer.setName(clue.getCompany());
        customer.setId(UUIDUtils.getUUID());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setOwner(user.getId());
        customer.setDescription(clue.getDescription());
        customer.setPhone(clue.getPhone());
        customer.setWebsite(clue.getWebsite());

        customerMapper.insertCustomer(customer);
        //拷贝一份线索表数据给联系人表
        Contacts contacts=new Contacts();
        contacts.setAddress(clue.getAddress());
        contacts.setAppellation(clue.getAppellation());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setCreateBy(user.getId());
        contacts.setCustomerId(customer.getId());
        contacts.setCreateTime(createTime);
        contacts.setDescription(clue.getDescription());
        contacts.setEmail(clue.getEmail());
        contacts.setId(UUIDUtils.getUUID());
        contacts.setSource(clue.getSource());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setOwner(clue.getOwner());
        contacts.setFullname(clue.getFullname());

        contactsMapper.insertContacts(contacts);
        //拷贝一份线索--备注表数据分别给客户备注表和联系人备注表
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkByClueId(clueId);
       if(clueRemarkList!=null&&clueRemarkList.size()!=0) {
           List<CustomerRemark> customerRemarkList = new ArrayList<CustomerRemark>();
           List<ContactsRemark> contactsRemarkList = new ArrayList<ContactsRemark>();
           CustomerRemark customerRemark = null;
           ContactsRemark contactsRemark = null;
           for (ClueRemark c : clueRemarkList) {
               customerRemark = new CustomerRemark();
               contactsRemark = new ContactsRemark();
               customerRemark.setCreateBy(c.getCreateBy());
               customerRemark.setCreateTime(c.getCreateTime());
               customerRemark.setCustomerId(customer.getId());
               customerRemark.setEditFlag(c.getEditFlag());
               customerRemark.setNoteContent(c.getNoteContent());
               customerRemark.setId(UUIDUtils.getUUID());
               customerRemarkList.add(customerRemark);
               contactsRemark.setContactsId(contacts.getId());
               contactsRemark.setCreateBy(c.getCreateBy());
               contactsRemark.setCreateTime(c.getCreateTime());
               contactsRemark.setEditFlag(c.getEditFlag());
               contactsRemark.setId(UUIDUtils.getUUID());
               contactsRemark.setNoteContent(c.getNoteContent());
               contactsRemarkList.add(contactsRemark);
           }

           customerRemarkMapper.insertCustomerRemarkList(customerRemarkList);
           contactsRemarkMapper.insertContactsRemarkList(contactsRemarkList);
       }
        //拷贝一份线索与市场活动关系表数据给联系人与市场活动关系表一份
           List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationMapper.selectClueActivityRelationByClue(clueId);
           ContactsActivityRelation contactsActivityRelation=null;
           List<ContactsActivityRelation>contactsActivityRelationList=new ArrayList<ContactsActivityRelation>();
            if(clueActivityRelationList!=null&&clueActivityRelationList.size()!=0){
                for (ClueActivityRelation c:clueActivityRelationList) {
                    contactsActivityRelation=new ContactsActivityRelation();
                    contactsActivityRelation.setId(UUIDUtils.getUUID());
                    contactsActivityRelation.setActivityId(c.getActivityId());
                    contactsActivityRelation.setContactsId(contacts.getId());
                    contactsActivityRelationList.add(contactsActivityRelation);
                }
            contactsActivityRelationMapper.insertContactsActivityRelationList(contactsActivityRelationList);
            }

//            创建交易
        if("true".equals(isCreateTran)){
                Transaction transaction=new Transaction();
                transaction.setActivityId((String) map.get("activityId"));
                transaction.setContactsId(contacts.getId());
                transaction.setCreateBy(user.getId());
                transaction.setCreateTime(createTime);
                transaction.setName((String) map.get("name"));
                transaction.setStage((String) map.get("stage"));
                transaction.setExpectedDate((String) map.get("expectedDate"));
                transaction.setCustomerId(customer.getId());
                transaction.setId(UUIDUtils.getUUID());
                transaction.setMoney((String) map.get("money"));
                transaction.setOwner(user.getId());
                transactionMapper.insertTransaction(transaction);


                //拷贝线索备注到交易备注一份
                List<TransactionRemark>transactionRemarkList=new ArrayList<TransactionRemark>();
                if(clueRemarkList!=null&&clueRemarkList.size()!=0){
                    for(ClueRemark c:clueRemarkList){
                        TransactionRemark t=new TransactionRemark();
                        t.setCreateBy(c.getCreateBy());
                        t.setCreateTime(c.getCreateTime());
                        t.setEditFlag(c.getEditFlag());
                        t.setId(UUIDUtils.getUUID());
                        t.setTranId(transaction.getId());
                        t.setNoteContent(c.getNoteContent());
                        t.setEditBy(c.getEditBy());
                        t.setEditTime(c.getEditTime());
                        transactionRemarkList.add(t);
                    }
                    transactionRemarkMapper.insertTransactionRemarkList(transactionRemarkList);
                }
                //删除线索的备注
                clueRemarkMapper.deleteClueRemarkListByClueId(clueId);
                //删除线索与市场活动关系
                clueActivityRelationMapper.deleteClueActivityRelationByClueId(clueId);
                //删除该线索
                clueMapper.deleteByPrimaryKey(clueId);
        }



    }

    @Override
    public int queryCountOfClueByCondition(Map<String, Object> map) {
        return clueMapper.selectCountOfClueByCondition(map);
    }

    @Override
    public List<Clue> queryClueByConditionForPage(Map<String, Object> map) {
        return clueMapper.selectClueByConditionForPage(map);
    }

    @Override
    public int updateClueById(Clue clue) {
        return clueMapper.updateByPrimaryKeySelective(clue);
    }

    @Override
    public int deleteClueByIds(String[] ids) {
        return clueMapper.deleteClueByIds(ids);
    }


}
