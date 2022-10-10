package person.otj.crm.workbench.mapper;

import person.otj.crm.workbench.model.Clue;

import java.util.List;
import java.util.Map;

public interface ClueMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Fri Sep 30 09:22:13 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Fri Sep 30 09:22:13 CST 2022
     */
    int insert(Clue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Fri Sep 30 09:22:13 CST 2022
     */
    int insertSelective(Clue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Fri Sep 30 09:22:13 CST 2022
     */
    Clue selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Fri Sep 30 09:22:13 CST 2022
     */
    int updateByPrimaryKeySelective(Clue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue
     *
     * @mbggenerated Fri Sep 30 09:22:13 CST 2022
     */
    int updateByPrimaryKey(Clue record);

    int insertClue(Clue clue);

    //根据id查询线索
    Clue selectClueForDetailById(String id);



    //根据id查询线索(查所有字段)
    Clue selectClueById(String id);

    //根据条件查询线索总条数
    int selectCountOfClueByCondition(Map<String,Object>map);

    //条件查询线索
    List<Clue>selectClueByConditionForPage(Map<String,Object>map);

    //根据ids删除线索
    int deleteClueByIds(String ids[]);



}