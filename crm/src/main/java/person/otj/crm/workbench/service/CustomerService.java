package person.otj.crm.workbench.service;


import person.otj.crm.workbench.model.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    List<String>queryCustomerNameByName(String customerName);
    int saveCreateCustomer(Customer customer);
    int queryCountOfCustomerByCondition(Map<String,Object>map);
    List<Customer>queryCustomerByConditionForPage(Map<String,Object>map);
    int updateCustomerById(Customer customer);
    Customer queryCustomerById(String id);
    void deleteCustomerByIds(String []ids);
    Customer queryCustomerForDetailById(String id);

    int isExistName(String cname);

    String queryIdByName(String customerId);

    String queryNameById(String customerId);
}
