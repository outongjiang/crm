package person.otj.crm.commons.utils;

import person.otj.crm.commons.contants.Contants;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

public class AddCookie {

    public static void  addCookie(Cookie cookie, HttpServletResponse response){
        cookie.setMaxAge(Contants.COOKIE_MAXAGE);
        response.addCookie(cookie);
    }
}
