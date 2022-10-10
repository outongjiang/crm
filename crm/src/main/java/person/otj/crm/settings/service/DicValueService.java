package person.otj.crm.settings.service;
import person.otj.crm.settings.model.DictionaryValue;
import java.util.List;
public interface DicValueService {
    List<DictionaryValue>queryDicValueByCodeType(String codeType);
    String queryStageOrderNoByValue(String value);
}
