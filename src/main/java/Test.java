import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.UUID;

class User {
    String name;
}
public class Test {
    public static void main(String[] args) {
        UUID uuid = UUID.randomUUID();
        System.out.println(uuid.toString().replace("-",""));
//        for (int i=0;i<=100;i++)
//        {
//            Date date=new Date();
//            int rnum=(int)(Math.random()*10)-7;
//            DateUtils.setMonth(date,date.getMonth()+1+(rnum<0?1:rnum));
//            date.setDate((int)(Math.random()*10)*2);
//            System.out.println(DateUtils.formateDateTimeSimple(date));
//        }
//
    }

}
