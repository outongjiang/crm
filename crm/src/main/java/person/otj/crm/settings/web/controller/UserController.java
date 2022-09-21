package person.otj.crm.settings.web.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import person.otj.crm.commons.contants.Contants;
import person.otj.crm.commons.domain.ReturnObject;
import person.otj.crm.commons.utils.DateUtils;
import person.otj.crm.settings.model.User;
import person.otj.crm.settings.service.UserService;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
@Controller
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){

        return "settings/qx/user/login";
    }
    @ResponseBody
    @RequestMapping("/settings/qx/user/login.do")
    public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpSession session){

        Map<String,Object>map=new HashMap<String, Object>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user=userService.queryUserByLoginActAndPwd(map);

        ReturnObject returnObject=new ReturnObject();
        if(user==null){
            //密码或账号错误
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("密码或账号错误");

        }else{
            String nowStr= DateUtils.formateDateTime(new Date());
            if(nowStr.compareTo(user.getExpireTime())>0){
                //账号过期
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("账号过期");
            }else if(Contants.RETURN_OBJECT_CODE_FILE.equals(user.getLockState())){
                //账号被锁定
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("账号被锁定");
            }else if(!user.getAllowIps().contains(request.getRemoteAddr())){
                //非法ip，ip受限
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("ip受限");
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                session.setAttribute(Contants.SESSION_USER,user);

            }
        }

         return returnObject;
    }
}
