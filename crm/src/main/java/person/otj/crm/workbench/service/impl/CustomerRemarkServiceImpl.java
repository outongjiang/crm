package person.otj.crm.workbench.service.impl;

import org.omg.CORBA.OBJ_ADAPTER;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import person.otj.crm.workbench.mapper.CustomerRemarkMapper;
import person.otj.crm.workbench.model.CustomerRemark;
import person.otj.crm.workbench.service.CustomerRemarkService;

import java.util.List;
import java.util.Map;

@Service
public class CustomerRemarkServiceImpl implements CustomerRemarkService {
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Override
    public List<CustomerRemark> queryCustomerRemarkListForDetailByCustomerId(String customerId) {
        return customerRemarkMapper.selectCustomerRemarkListForDetailByCustomerId(customerId);
    }

    @Override
    public int saveCreateCustomerRemark(CustomerRemark remark) {
        return customerRemarkMapper.insertCustomerRemark(remark);
    }

    @Override
    public int saveEditCustomerRemark(CustomerRemark remark) {
        return customerRemarkMapper.updateByPrimaryKeySelective(remark);
    }

    @Override
    public int deleteCustomerRemarkById(String id) {
        return customerRemarkMapper.deleteCustomerRemarkById(id);
    }
}
