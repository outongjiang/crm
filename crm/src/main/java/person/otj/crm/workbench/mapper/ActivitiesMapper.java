package person.otj.crm.workbench.mapper;

import person.otj.crm.workbench.model.Activities;

public interface ActivitiesMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Fri Sep 23 10:55:57 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Fri Sep 23 10:55:57 CST 2022
     */
    int insert(Activities record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Fri Sep 23 10:55:57 CST 2022
     */
    int insertSelective(Activities record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Fri Sep 23 10:55:57 CST 2022
     */
    Activities selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Fri Sep 23 10:55:57 CST 2022
     */
    int updateByPrimaryKeySelective(Activities record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Fri Sep 23 10:55:57 CST 2022
     */
    int updateByPrimaryKey(Activities record);
}