package person.otj.crm.settings.mapper;

import person.otj.crm.settings.model.DictionaryValue;

import java.util.List;

public interface DictionaryValueMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Fri Sep 30 00:52:43 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Fri Sep 30 00:52:43 CST 2022
     */
    int insert(DictionaryValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Fri Sep 30 00:52:43 CST 2022
     */
    int insertSelective(DictionaryValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Fri Sep 30 00:52:43 CST 2022
     */
    DictionaryValue selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Fri Sep 30 00:52:43 CST 2022
     */
    int updateByPrimaryKeySelective(DictionaryValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Fri Sep 30 00:52:43 CST 2022
     */
    int updateByPrimaryKey(DictionaryValue record);

    /*根据codeType查询DictionaryValue*/
    List<DictionaryValue> selectDicValueByCodeType(String codeType);


    //根据阶段名称查询阶段顺序
    String selectStageOrderNoByValue(String value);

}