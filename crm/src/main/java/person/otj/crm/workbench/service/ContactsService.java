package person.otj.crm.workbench.service;

import person.otj.crm.commons.contants.Contants;
import person.otj.crm.workbench.model.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsService {
    List<Contants> queryContactForTransactionSaveByName(String fullname);

    List<Contants> QueryContactAll();

    int saveCreateContact(Contacts contacts);

    List<Contacts>queryContactForCustomerDetailById(String id);
    void deleteContactForCustomerDetailByContactId(String id);

    Contacts queryContactById(String id);

    int queryCountOfContactByCondition(Map<String, Object> map);

    List<Contacts> queryClueByConditionForPage(Map<String, Object> map);

    int saveEditContact(Contacts contacts);

    void deleteContactByIds(String[] ids);

    Contacts queryContactForDetailById(String contactId);
}
