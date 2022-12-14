package person.otj.crm.workbench.service;

import person.otj.crm.workbench.model.Activities;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    int saveCreateActivity(Activities record);
    List<Activities> querycActivityByConditionForPage(Map<String,Object>map);
    int queryCountOfActivityByCondition(Map<String,Object>map);
    int deleteActivityByIds(String ids[]);
    int updateActivityById(Activities records);
    Activities queryActivityById(String id);
    List<Activities>QueryActivityAll();
    List<Activities>QueryActivityByIds(String ids[]);
    int saveCreateActivityList(List<Activities> activities);
    List<Activities>queryActivityForDetailByClueId(String clueId);
    List<Activities>queryActivityForDetailByNameClueId(Map<String,Object>map);
    List<Activities>queryActivityForDetailByIds(String ids[]);
    List<Activities>queryActivityForConvertByNameClueId(Map<String,Object>map);

    List<Activities> queryActivityForCustomerDetailByName(String activityName);

    List<Activities> queryActivityForContactsDetailByContactId(String contactId);

    List<Activities> queryActivityForDetailByNameContactId(Map<String, Object> map);
}
