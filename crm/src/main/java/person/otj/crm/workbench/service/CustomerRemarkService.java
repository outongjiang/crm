package person.otj.crm.workbench.service;


import person.otj.crm.workbench.model.CustomerRemark;

import java.util.List;
import java.util.Map;

public interface CustomerRemarkService {
    List<CustomerRemark>queryCustomerRemarkListForDetailByCustomerId(String customerId);
    int saveCreateCustomerRemark(CustomerRemark remark);
    int saveEditCustomerRemark(CustomerRemark remark);
    int deleteCustomerRemarkById(String id);


}
