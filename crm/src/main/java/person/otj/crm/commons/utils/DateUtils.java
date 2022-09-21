package person.otj.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtils {
    public static String  formateDateTime(Date date){
        SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String nowStr=simpleDateFormat.format(date);
        return nowStr;
    }



}
