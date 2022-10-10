package person.otj.crm.workbench.service;

import person.otj.crm.workbench.model.TransactionRemark;

import java.util.List;

public interface TransactionRemarkService {
    List<TransactionRemark>queryTransactionRemarkListForDetailByTranId(String tranId);

    int saveCreateTranRemark(TransactionRemark remark);

    int saveEditCustomerRemark(TransactionRemark remark);

    int deleteTranRemarkById(String id);
}
