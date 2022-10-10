package person.otj.crm.workbench.service;

import person.otj.crm.workbench.model.ClueRemark;

import java.util.List;

public interface ClueRemarkService {
    List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId);
    List<ClueRemark>queryClueRemarkByClueId(String clueId);
    int saveCreateClueRemark(ClueRemark remark);
    int deleteClueRemarkById(String id);
    int saveEditClueRemark(ClueRemark remark);
}
