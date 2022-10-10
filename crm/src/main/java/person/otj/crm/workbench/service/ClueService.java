package person.otj.crm.workbench.service;

import org.springframework.stereotype.Service;
import person.otj.crm.workbench.model.Clue;
import person.otj.crm.workbench.model.ClueRemark;

import java.util.List;
import java.util.Map;


public interface ClueService{
    int saveCreateClue(Clue clue);
    Clue queryClueForDetailById(String id);
    Clue queryClueById(String id);
    void saveConvertClue(Map<String,Object> map);
    int queryCountOfClueByCondition(Map<String,Object> map);
    List<Clue>queryClueByConditionForPage(Map<String,Object> map);
    int updateClueById(Clue clue);
    int deleteClueByIds(String []ids);

}
