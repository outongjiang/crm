package person.otj.crm.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import person.otj.crm.workbench.mapper.ActivitiesMapper;
import person.otj.crm.workbench.model.Activities;
import person.otj.crm.workbench.service.ActivityService;

import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivitiesMapper activitiesMapper;
    public int saveCreateActivity(Activities record) {
        return activitiesMapper.insertSelective(record);
    }

    public List<Activities> querycActivityByConditionForPage(Map<String, Object> map) {
        return activitiesMapper.selectActivityByConditionForPage(map);
    }

    public int queryCountOfActivityByCondition(Map<String, Object> map) {
        return activitiesMapper.selectCountOfActivityByCondition(map);
    }

    public int deleteActivityByIds(String[] ids) {
        return activitiesMapper.deleteActivityByIds(ids);
    }

    public int updateActivityById(Activities records) {
        return activitiesMapper.updateByPrimaryKeySelective(records);
    }

    public Activities queryActivityById(String id) {
        return activitiesMapper.selectActivityById(id);
    }

    public List<Activities> QueryActivityAll() {
        return activitiesMapper.selectActivityAll();
    }

    public List<Activities> QueryActivityByIds(String[] ids) {
        return activitiesMapper.selectActivityByIds(ids);
    }

    public int saveCreateActivityList(List<Activities> activities) {
        return activitiesMapper.insertActivityList(activities);
    }

    public List<Activities> queryActivityForDetailByClueId(String clueId) {
        return activitiesMapper.selectActivityForDetailByClueId(clueId);
    }

    public List<Activities> queryActivityForDetailByNameClueId(Map<String, Object> map) {
        return activitiesMapper.selectActivityForDetailByNameClueId(map);
    }

    public List<Activities> queryActivityForDetailByIds(String[] ids) {
        return activitiesMapper.selectActivityForDetailByIds(ids);
    }

    public List<Activities> queryActivityForConvertByNameClueId(Map<String, Object> map) {
        return activitiesMapper.selectActivityForConvertByNameClueId(map);
    }

    @Override
    public List<Activities> queryActivityForCustomerDetailByName(String activityName) {
        return activitiesMapper.selectActivityForCustomerDetailByName(activityName);
    }

    @Override
    public List<Activities> queryActivityForContactsDetailByContactId(String contactId) {
        return activitiesMapper.selectActivityListForContactDetailByContactId(contactId);
    }

    @Override
    public List<Activities> queryActivityForDetailByNameContactId(Map<String, Object> map) {
        return activitiesMapper.selectActivityForDetailByNameContactId(map);
    }
}