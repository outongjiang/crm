package person.otj.crm.workbench.mapper;

import org.w3c.dom.ls.LSInput;
import person.otj.crm.workbench.model.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Fri Sep 30 11:10:52 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Fri Sep 30 11:10:52 CST 2022
     */
    int insert(ClueRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Fri Sep 30 11:10:52 CST 2022
     */
    int insertSelective(ClueRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Fri Sep 30 11:10:52 CST 2022
     */
    ClueRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Fri Sep 30 11:10:52 CST 2022
     */
    int updateByPrimaryKeySelective(ClueRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_remark
     *
     * @mbggenerated Fri Sep 30 11:10:52 CST 2022
     */
    int updateByPrimaryKey(ClueRemark record);

    //根据线索Id查询线索明细信息
    List<ClueRemark>selectClueRemarkForDetailByClueId(String clueId);

    List<ClueRemark>selectClueRemarkByClueId(String clueId);

    int insertClueRemark(ClueRemark remark);

    //根据clueId删除该线索下所有备注
    int deleteClueRemarkListByClueId(String clueId);

    //根据id删除线索备注
    int deleteClueRemarkById(String id);


}