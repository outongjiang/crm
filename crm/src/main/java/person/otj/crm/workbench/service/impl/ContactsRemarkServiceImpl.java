package person.otj.crm.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import person.otj.crm.workbench.mapper.ContactsRemarkMapper;
import person.otj.crm.workbench.model.ContactsRemark;
import person.otj.crm.workbench.service.ContactsRemarkService;

import java.util.List;

@Service
public class ContactsRemarkServiceImpl implements ContactsRemarkService {
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Override
    public int saveCreateContactsRemark(ContactsRemark remark) {
        return contactsRemarkMapper.insert(remark);
    }

    @Override
    public List<ContactsRemark> queryContactsRemarkList(String contactId) {
        return contactsRemarkMapper.selectContactsRemarkList(contactId);
    }

    @Override
    public int deleteContactRemarkById(String id) {
        return contactsRemarkMapper.deleteContactRemarkById(id);
    }

    @Override
    public int saveEditContactsRemark(ContactsRemark remark) {
        return contactsRemarkMapper.updateByPrimaryKeySelective(remark);
    }
}
