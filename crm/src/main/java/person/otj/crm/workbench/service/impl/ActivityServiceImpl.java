package person.otj.crm.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import person.otj.crm.workbench.mapper.ActivitiesMapper;
import person.otj.crm.workbench.model.Activities;
import person.otj.crm.workbench.service.ActivityService;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivitiesMapper activitiesMapper;
    public int saveCreateActivity(Activities record) {
        return activitiesMapper.insertACtivity(record);
    }
}
