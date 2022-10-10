package person.otj.crm.workbench.service;
import person.otj.crm.workbench.model.Activities;
import person.otj.crm.workbench.model.ContactsActivityRelation;

import java.util.List;
import java.util.Map;

public interface ContactsActivityRelationService {

    int deleteContactsActivityRelationByActivityIdContactsId(Map<String, Object> map);

    int saveCreateContactActivityRelationByList(List<ContactsActivityRelation> list);
}
