package person.otj.crm.workbench.service.impl;
import org.omg.CORBA.PRIVATE_MEMBER;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import person.otj.crm.workbench.mapper.*;
import person.otj.crm.workbench.model.Customer;
import person.otj.crm.workbench.service.CustomerService;
import java.util.List;
import java.util.Map;
@Service
public class CustomerServiceImpl implements CustomerService {


    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;
    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    public List<String> queryCustomerNameByName(String customerName) {
        return customerMapper.selectCustomerNameByName(customerName);
    }

    @Override
    public int saveCreateCustomer(Customer customer) {
        return customerMapper.insertSelective(customer);
    }

    @Override
    public int queryCountOfCustomerByCondition(Map<String, Object> map) {
        return customerMapper.selectCountOfCustomerByCondition(map);
    }

    @Override
    public List<Customer> queryCustomerByConditionForPage(Map<String,Object>map) {
        return customerMapper.selectCustomerByConditionForPage(map);
    }

    @Override
    public int updateCustomerById(Customer customer) {
        return customerMapper.updateByPrimaryKeySelective(customer);
    }

    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectCustomerById(id);
    }
    //根据id批量删除 删除包括客户 ，客户备注，客户下的交易，客户下的联系人
    @Override
    public void deleteCustomerByIds(String[] ids) {

//        String constactId[]=contactsMapper.selectIdByCustomerIds(ids);
//        String tranId[]=transactionMapper.selectIdsByCustomerIds(ids);
        //System.out.println(tranId.length);
        for(String id:ids) {
            String tranId=transactionMapper.selectIdByCustomerId(id);
            String contactId=contactsMapper.selectIdByCustomerId(id);
            transactionRemarkMapper.deleteRemarkByTranId(tranId);
            transactionHistoryMapper.deleteHistoryTranId(tranId);
            contactsRemarkMapper.deleteRemarkByContactId(contactId);
            contactsActivityRelationMapper.deleteActivityRelationByContactId(contactId);
        }

        transactionMapper.deleteTranForDetailByCustomerIds(ids);
        contactsMapper.deleteContactByCustomerIds(ids);
        customerRemarkMapper.deleteCustomerRemarkByIds(ids);
        customerMapper.deleteCustomerByIds(ids);

    }

    @Override
    public Customer queryCustomerForDetailById(String id) {
        return customerMapper.selectCustomerForDetailById(id);
    }

    @Override
    public int isExistName(String cname) {
        return customerMapper.findCustomerByName(cname);
    }

    @Override
    public String queryIdByName(String customerId) {
        return customerMapper.selectIdByName(customerId);
    }

    @Override
    public String queryNameById(String customerId) {
        return customerMapper.selectNameById(customerId);
    }
}
