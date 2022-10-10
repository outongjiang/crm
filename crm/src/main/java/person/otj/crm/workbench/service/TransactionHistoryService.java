package person.otj.crm.workbench.service;

import person.otj.crm.workbench.model.TransactionHistory;

import java.util.List;

public interface TransactionHistoryService {
    List<TransactionHistory>querytTransactionHistoryListForDetailByTranId(String tranId);
}
