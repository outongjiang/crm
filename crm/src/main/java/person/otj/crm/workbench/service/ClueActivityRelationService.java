package person.otj.crm.workbench.service;


import person.otj.crm.workbench.model.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationService {
    int saveCreateClueActivityRelationByList(List<ClueActivityRelation>list);
    int deleteClueActivityRelationByActivityIdClueId(Map<String,Object> map);
}
