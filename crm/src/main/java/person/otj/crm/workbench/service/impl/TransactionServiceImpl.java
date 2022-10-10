package person.otj.crm.workbench.service.impl;
import org.apache.poi.sl.draw.geom.ArcTanExpression;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import person.otj.crm.commons.contants.Contants;
import person.otj.crm.commons.domain.FunnelVo;
import person.otj.crm.commons.utils.DateUtils;
import person.otj.crm.commons.utils.UUIDUtils;
import person.otj.crm.settings.model.User;
import person.otj.crm.workbench.mapper.CustomerMapper;
import person.otj.crm.workbench.mapper.TransactionHistoryMapper;
import person.otj.crm.workbench.mapper.TransactionMapper;
import person.otj.crm.workbench.mapper.TransactionRemarkMapper;
import person.otj.crm.workbench.model.Customer;
import person.otj.crm.workbench.model.Transaction;
import person.otj.crm.workbench.service.TransactionService;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("transactionService")
public class TransactionServiceImpl implements TransactionService {

    @Autowired
    private TransactionMapper transactionMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;

    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;

    @Override
    public void saveCreateTran(Map<String, Object> map) {
        String customerName=(String) map.get("customerName");
        User user=(User)map.get(Contants.SESSION_USER);
        Customer customer = customerMapper.selectCustomerByName(customerName);
        if(customer==null){
            customer=new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setName(customerName);
            customer.setOwner(user.getId());
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtils.formateDateTime(new Date()));
            customerMapper.insertCustomer(customer);
        }
        Transaction transaction=new Transaction();
        transaction.setId(UUIDUtils.getUUID());
        transaction.setCustomerId(customer.getId());
        transaction.setStage((String)map.get("stage"));
        transaction.setOwner((String)map.get("owner"));
        transaction.setNextContactTime((String)map.get("nextContactTime"));
        transaction.setName((String)map.get("name"));
        transaction.setMoney((String)map.get("money"));
        transaction.setExpectedDate((String)map.get("expectedDate"));
        transaction.setCreateTime(DateUtils.formateDateTime(new Date()));
        transaction.setCreateBy(user.getId());
        transaction.setContactSummary((String)map.get("contactSummary"));
        transaction.setContactsId((String)map.get("contactsId"));
        transaction.setActivityId((String)map.get("activityId"));
        transaction.setDescription((String)map.get("description"));
        transaction.setSource((String)map.get("source"));
        transaction.setType((String)map.get("type"));
        transactionMapper.insertTransaction(transaction);
    }

    @Override
    public Transaction queryTransactionForDetailById(String tranId) {
        return transactionMapper.selectTransactionForDetailById(tranId);
    }

    @Override
    public List<FunnelVo> queryCountOfTranGroupByStage() {
        return transactionMapper.selectCountOfTranGroupByStage();
    }

    @Override
    public List<Transaction> queryTransactionForCustomerDetailByCustomerId(String id) {
        return transactionMapper.selectTransactionForCustomerDetailByCustomerId(id);
    }

    //删除交易信息，交易备注 以及 交易历史
    @Override
    public void deleteTranForCustomerDetailByTranId(String id) {
        transactionMapper.deleteTranForCustomerDetailById(id);
        transactionRemarkMapper.deleteTranRemarkForCustomerDetailByTranId(id);
        transactionHistoryMapper.deleteTranHistoryForCustomerDetailByTranId(id);
    }

    @Override
    public List<Transaction> queryTransactionForContactsDetailByContactsId(String contactId) {
        return transactionMapper.selectTransactionForContactsDetailByContactsId(contactId);
    }

    @Override
    public int queryCountOfTransactionByCondition(Map<String, Object> map) {
        return transactionMapper.selectCountOfTransactionByCondition(map);
    }

    @Override
    public List<Transaction> queryTransactionByConditionForPage(Map<String, Object> map) {
        return transactionMapper.selectTransactionByConditionForPage(map);
    }

    @Override
    public void deleteTranByIds(String[] ids) {
        transactionRemarkMapper.deleteRemarkByTranIds(ids);
        transactionHistoryMapper.deleteHistoryTranIds(ids);
        transactionMapper.deleteTranByIds(ids);
    }

    @Override
    public Transaction queryTransactionForEditById(String id) {
        return transactionMapper.selectTransactionForEditById(id);
    }

    @Override
    public int saveEditTran(Transaction transaction) {
        return transactionMapper.updateByPrimaryKeySelective(transaction);
    }
}
