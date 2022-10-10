package person.otj.crm.settings.service.impl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import person.otj.crm.settings.mapper.DictionaryValueMapper;
import person.otj.crm.settings.model.DictionaryValue;
import person.otj.crm.settings.service.DicValueService;
import java.util.List;
@Service
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    private DictionaryValueMapper dictionaryValueMapper;

    public List<DictionaryValue> queryDicValueByCodeType(String codeType) {
        return dictionaryValueMapper.selectDicValueByCodeType(codeType);
    }

    @Override
    public String queryStageOrderNoByValue(String value) {
        return dictionaryValueMapper.selectStageOrderNoByValue(value);
    }

}