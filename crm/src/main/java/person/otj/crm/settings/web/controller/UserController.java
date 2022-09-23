package person.otj.crm.settings.web.controller;
import com.alibaba.druid.pool.PreparedStatementPool;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import person.otj.crm.commons.contants.Contants;
import person.otj.crm.commons.domain.ReturnObject;
import person.otj.crm.commons.utils.AddCookie;
import person.otj.crm.commons.utils.DateUtils;
import person.otj.crm.settings.model.User;
import person.otj.crm.settings.service.UserService;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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

    @RequestMapping("/settings/qx/user/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletResponse response, HttpServletRequest request, HttpSession session){

        Map<String,Object>map=new HashMap<String, Object>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
//        User user=new User();
//        user=userService.queryUserByLoginActAndPwd(map);
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
                //记住用户信息
                session.setAttribute(Contants.SESSION_USER,user);
                //如果需要记住登录密码
                if("true".equals(isRemPwd)){
                    Cookie loginActcookie = new Cookie("loginAct", user.getLoginAct());
                    Cookie loginPwdcookie = new Cookie("loginPwd", user.getLoginPwd());
                    //十天自动删除cookie
                    //utils 里面AddCookie工具类里面addCookie方法添加cookie
                    AddCookie.addCookie(loginActcookie,response);
                    AddCookie.addCookie(loginPwdcookie,response);
                }else{
                    Cookie c1=new Cookie("loginAct","1");
                    c1.setMaxAge(0);
                    Cookie c2=new Cookie("loginPwd","1");
                    c2.setMaxAge(0);
                    response.addCookie(c1);
                    response.addCookie(c2);
                }


                //如果需要记住密码，则往外写cookie

            }
        }

         return returnObject;
    }

    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletResponse response,HttpServletRequest request,HttpSession session){
        //销毁记住用户账号密码的cookie
        Cookie c1=new Cookie("loginAct","1");
        c1.setMaxAge(0);
        Cookie c2=new Cookie("loginPwd","1");
        c2.setMaxAge(0);
        response.addCookie(c1);
        response.addCookie(c2);
        //销毁存放用户信息的session
        session.invalidate();
        return "redirect:/";
    }
}
