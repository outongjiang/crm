package person.otj.crm.settings.service;

import org.springframework.stereotype.Service;
import person.otj.crm.settings.model.User;

import java.util.List;
import java.util.Map;


public interface UserService {
    User queryUserByLoginActAndPwd(Map<String,Object>map);
    List<User> findAll();
}
