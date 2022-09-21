package person.otj.crm.settings.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import person.otj.crm.settings.mapper.UserMapper;
import person.otj.crm.settings.model.User;
import person.otj.crm.settings.service.UserService;

import java.util.List;
import java.util.Map;
@Service

public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;


    public User queryUserByLoginActAndPwd(Map<String, Object> map) {
        return userMapper.selectUserByLoginActAndPwd(map);
    }

    public List<User> findAll() {
         return userMapper.findAll();
    }
}
