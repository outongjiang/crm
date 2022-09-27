package person.otj.crm.commons.utils;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.io.InputStream;
import java.io.OutputStream;

public class ResourceUtils {
    public static void resourceClose(InputStream inputStream, OutputStream out, HSSFWorkbook wb){
        try{
        inputStream.close();
       }
        catch (Exception e){
            e.printStackTrace();
        }

        try{
            out.close();
        }
        catch (Exception e){
            e.printStackTrace();
        }
        try{
            wb.close();
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }

}
