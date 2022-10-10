package person.otj.crm.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import person.otj.crm.workbench.mapper.TransactionHistoryMapper;
import person.otj.crm.workbench.model.TransactionHistory;
import person.otj.crm.workbench.service.TransactionHistoryService;

import java.util.List;

@Service
public class TransactionHistoryServiceImpl implements TransactionHistoryService {
    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;
    @Override
    public List<TransactionHistory> querytTransactionHistoryListForDetailByTranId(String tranId) {
        return transactionHistoryMapper.selectTransactionHistoryListForDetailByTranId(tranId);
    }
}
