package person.otj.crm.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import person.otj.crm.workbench.mapper.TransactionRemarkMapper;
import person.otj.crm.workbench.model.TransactionRemark;
import person.otj.crm.workbench.service.TransactionRemarkService;
import person.otj.crm.workbench.service.TransactionService;

import java.util.List;

@Service
public class TransactionRemarkServiceImpl implements TransactionRemarkService{
    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;
    @Override
    public List<TransactionRemark> queryTransactionRemarkListForDetailByTranId(String tranId) {
        return transactionRemarkMapper.selectTransactionRemarkListForDetailByTranId(tranId);
    }

    @Override
    public int saveCreateTranRemark(TransactionRemark remark) {
        return transactionRemarkMapper.insert(remark);
    }

    @Override
    public int saveEditCustomerRemark(TransactionRemark remark) {
        return transactionRemarkMapper.updateByPrimaryKeySelective(remark);
    }

    @Override
    public int deleteTranRemarkById(String id) {
        return transactionRemarkMapper.deleteByPrimaryKey(id);
    }
}
