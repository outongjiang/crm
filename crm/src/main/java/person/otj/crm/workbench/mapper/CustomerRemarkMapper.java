package person.otj.crm.workbench.mapper;

import person.otj.crm.workbench.model.CustomerRemark;

import java.util.List;
import java.util.Map;

public interface CustomerRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Oct 03 15:24:05 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Oct 03 15:24:05 CST 2022
     */
    int insert(CustomerRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Oct 03 15:24:05 CST 2022
     */
    int insertSelective(CustomerRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Oct 03 15:24:05 CST 2022
     */
    CustomerRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Oct 03 15:24:05 CST 2022
     */
    int updateByPrimaryKeySelective(CustomerRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Oct 03 15:24:05 CST 2022
     */
    int updateByPrimaryKey(CustomerRemark record);


    int insertCustomerRemarkList(List<CustomerRemark>customerRemarkList);

    List<CustomerRemark>selectCustomerRemarkListForDetailByCustomerId(String customerId);
    int insertCustomerRemark(CustomerRemark remark);

    int deleteCustomerRemarkById(String id);

    int deleteCustomerRemarkByIds(String[] ids);


}