package person.otj.crm.workbench.service;

import person.otj.crm.workbench.model.ActivitiesRemark;

import java.util.List;

public interface ActivityRemarkService {
    List<ActivitiesRemark> queryActivityRemarkForDetailByActivityId(String activityId);
    int saveCreateActivityRemark(ActivitiesRemark remark);
    int deleteActivityRemarkById(String id);
    int saveEditActivityRemark(ActivitiesRemark remark);

}
