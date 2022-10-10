package person.otj.crm.workbench.service.impl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import person.otj.crm.commons.contants.Contants;
import person.otj.crm.workbench.mapper.ContactsActivityRelationMapper;
import person.otj.crm.workbench.mapper.ContactsMapper;
import person.otj.crm.workbench.mapper.ContactsRemarkMapper;
import person.otj.crm.workbench.model.Contacts;
import person.otj.crm.workbench.service.ContactsService;
import java.util.List;
import java.util.Map;

@Service
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Override
    public List<Contants> queryContactForTransactionSaveByName(String fullname) {
        return contactsMapper.selectContactForTransactionSaveByName(fullname);
    }

    @Override
    public List<Contants> QueryContactAll() {
        return contactsMapper.QueryContactAll();
    }

    @Override
    public int saveCreateContact(Contacts contacts) {
        return contactsMapper.insertContacts(contacts);
    }

    @Override
    public List<Contacts> queryContactForCustomerDetailById(String id) {
        return contactsMapper.selectContactForCustomerDetailById(id);
    }

    //删除联系人 联系人备注 联系人与市场活动关系
    @Override
    public void deleteContactForCustomerDetailByContactId(String id) {
        contactsMapper.deleteByPrimaryKey(id);
        contactsRemarkMapper.deleteContactRemarkByContactId(id);
        contactsActivityRelationMapper.deleteContactsActivityRelationById(id);
    }

    @Override
    public Contacts queryContactById(String id) {
        return contactsMapper.selectByPrimaryKey(id);
    }

    @Override
    public int queryCountOfContactByCondition(Map<String, Object> map) {
        return contactsMapper.selectCountOfContactByCondition(map);
    }

    @Override
    public List<Contacts> queryClueByConditionForPage(Map<String, Object> map) {
        return contactsMapper.selectClueByConditionForPage(map);
    }

    @Override
    public int saveEditContact(Contacts contacts) {
        return contactsMapper.updateByPrimaryKeySelective(contacts);
    }

    @Override
    public void deleteContactByIds(String[] ids) {
        contactsRemarkMapper.deleteContactRemarkByContactIds(ids);

        contactsActivityRelationMapper.deleteContactsActivityRelationByIds(ids);

        contactsMapper.deleteContactByIds(ids);
    }

    @Override
    public Contacts queryContactForDetailById(String contactId) {
        return contactsMapper.selectContactForDetailById(contactId);
    }
}
