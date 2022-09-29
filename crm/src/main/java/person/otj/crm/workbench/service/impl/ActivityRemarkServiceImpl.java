package person.otj.crm.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import person.otj.crm.workbench.mapper.ActivitiesRemarkMapper;
import person.otj.crm.workbench.model.ActivitiesRemark;
import person.otj.crm.workbench.service.ActivityRemarkService;

import java.util.List;


@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {
    @Autowired
    private ActivitiesRemarkMapper activitiesRemarkMapper;

    public List<ActivitiesRemark> queryActivityRemarkForDetailByActivityId(String activityId) {
        return activitiesRemarkMapper.selectActivityRemarkForDetailByActivityId(activityId);
    }

    public int saveCreateActivityRemark(ActivitiesRemark remark) {
        return activitiesRemarkMapper.insertCreateActivityRemark(remark);
    }

    public int deleteActivityRemarkById(String id) {
        return activitiesRemarkMapper.deleteActivityRemarkById(id);
    }

    public int saveEditActivityRemark(ActivitiesRemark remark) {
        return activitiesRemarkMapper.updateByPrimaryKeySelective(remark);
    }


}
