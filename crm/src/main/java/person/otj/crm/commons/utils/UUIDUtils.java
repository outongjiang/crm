package person.otj.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

public class UUIDUtils {
    public static String  getUUID(){

        return UUID.randomUUID().toString().replace("-","");
    }
}
