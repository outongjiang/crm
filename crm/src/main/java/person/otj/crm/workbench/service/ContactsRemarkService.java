package person.otj.crm.workbench.service;


import person.otj.crm.workbench.model.ContactsRemark;

import java.util.List;

public interface ContactsRemarkService {

    int saveCreateContactsRemark(ContactsRemark remark);

    List<ContactsRemark> queryContactsRemarkList(String contactId);

    int deleteContactRemarkById(String id);

    int saveEditContactsRemark(ContactsRemark remark);
}
