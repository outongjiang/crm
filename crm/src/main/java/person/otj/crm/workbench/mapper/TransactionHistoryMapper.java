package person.otj.crm.workbench.mapper;

import person.otj.crm.workbench.model.TransactionHistory;

import java.util.List;

public interface TransactionHistoryMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Thu Oct 06 19:57:31 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Thu Oct 06 19:57:31 CST 2022
     */
    int insert(TransactionHistory record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Thu Oct 06 19:57:31 CST 2022
     */
    int insertSelective(TransactionHistory record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Thu Oct 06 19:57:31 CST 2022
     */
    TransactionHistory selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Thu Oct 06 19:57:31 CST 2022
     */
    int updateByPrimaryKeySelective(TransactionHistory record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_history
     *
     * @mbggenerated Thu Oct 06 19:57:31 CST 2022
     */
    int updateByPrimaryKey(TransactionHistory record);

    //根据交易id查询所有交易历史
    List<TransactionHistory>selectTransactionHistoryListForDetailByTranId(String tranId);

    int deleteTranHistoryForCustomerDetailByTranId(String id);

    int deleteTransactionHistoryByIds(String[] tranId);

    int deleteHistoryTranId(String tranId);

    int deleteHistoryTranIds(String[] ids);
}