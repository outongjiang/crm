package person.otj.crm.workbench.service;

import org.omg.CORBA.OBJ_ADAPTER;
import person.otj.crm.commons.domain.FunnelVo;
import person.otj.crm.workbench.model.Transaction;

import java.util.List;
import java.util.Map;

public interface TransactionService {
    void saveCreateTran(Map<String,Object>map);
    Transaction queryTransactionForDetailById(String tranId);
    List<FunnelVo>queryCountOfTranGroupByStage();

    List<Transaction> queryTransactionForCustomerDetailByCustomerId(String id);

    void deleteTranForCustomerDetailByTranId(String id);

    List<Transaction> queryTransactionForContactsDetailByContactsId(String contactId);

    int queryCountOfTransactionByCondition(Map<String, Object> map);

    List<Transaction> queryTransactionByConditionForPage(Map<String, Object> map);

    void deleteTranByIds(String[] ids);

    Transaction queryTransactionForEditById(String id);

    int saveEditTran(Transaction transaction);
}
