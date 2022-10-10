package person.otj.crm.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import person.otj.crm.workbench.mapper.ContactsActivityRelationMapper;
import person.otj.crm.workbench.model.Activities;
import person.otj.crm.workbench.model.ContactsActivityRelation;
import person.otj.crm.workbench.service.ContactsActivityRelationService;

import java.util.List;
import java.util.Map;

@Service
public class ContactsActivityRelationServiceImpl implements ContactsActivityRelationService {
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Override
    public int deleteContactsActivityRelationByActivityIdContactsId(Map<String, Object> map) {
        return contactsActivityRelationMapper.deleteActivityRelationByContactIdActivityId(map);
    }

    @Override
    public int saveCreateContactActivityRelationByList(List<ContactsActivityRelation> list) {
        return contactsActivityRelationMapper.insertCreateContactActivityRelationByList(list);
    }
}
