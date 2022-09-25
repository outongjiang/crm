import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtils {
    public static String  formateDateTime(Date date){
        SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String nowStr=simpleDateFormat.format(date);
        return nowStr;
    }

    public static String  formateDateTimeSimple(Date date){
        SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd");
        String nowStr=simpleDateFormat.format(date);
        return nowStr;
    }

    public static void setYear(Date date,int year){
        date.setYear(year-1900);
    }
    public static void setMonth(Date date,int month){
        date.setMonth(month-1);
    }


}
