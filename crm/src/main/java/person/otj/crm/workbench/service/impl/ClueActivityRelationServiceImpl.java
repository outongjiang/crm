package person.otj.crm.workbench.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import person.otj.crm.workbench.mapper.ClueActivityRelationMapper;
import person.otj.crm.workbench.model.ClueActivityRelation;
import person.otj.crm.workbench.service.ClueActivityRelationService;

import java.util.List;
import java.util.Map;

@Service
public class ClueActivityRelationServiceImpl  implements ClueActivityRelationService {
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    public int saveCreateClueActivityRelationByList(List<ClueActivityRelation> list) {
        return clueActivityRelationMapper.insertClueActivityRelationByList(list);
    }

    public int deleteClueActivityRelationByActivityIdClueId(Map<String,Object> map) {
        return clueActivityRelationMapper.deleteClueActivityRelationByActivityIdClueId(map);
    }
}
