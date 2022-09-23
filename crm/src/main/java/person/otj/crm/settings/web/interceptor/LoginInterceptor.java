package person.otj.crm.settings.web.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;
import person.otj.crm.commons.contants.Contants;
import person.otj.crm.settings.model.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginInterceptor implements HandlerInterceptor {

    public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o) throws Exception {
        //如果用户没有登录,跳转登录页面
        HttpSession session = httpServletRequest.getSession();
         User user= (User) session.getAttribute(Contants.SESSION_USER);
         if(user!=null){
             return true;
         }
                //使用sendRedirect要使用/crm
                //而在controller里面直接/ mvc会自动加项目名crm
         httpServletResponse.sendRedirect("/crm");
        return false;
    }

    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }

    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }
}
