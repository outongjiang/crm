package person.otj.crm.commons.utils;

import person.otj.crm.commons.contants.Contants;
import person.otj.crm.commons.domain.ReturnObject;

public class CUDExceptionUtils {
    public static void  CUDExceptionHandler(int i, ReturnObject returnObject){
        try {
            if(i>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("执行成功!");
            }else{
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
                returnObject.setMessage("系统繁忙,请稍后重试.......");
            }
        }catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FILE);
            returnObject.setMessage("系统繁忙,请稍后重试.......");
        }
    }
}
