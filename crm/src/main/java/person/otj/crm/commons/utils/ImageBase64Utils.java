package person.otj.crm.commons.utils;
import javax.servlet.http.HttpServletRequest;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Base64;
public class ImageBase64Utils {

    public static String getImageBase64(HttpServletRequest request,String imageName){
        String base64=null;
        String realPath = request.getServletContext().getRealPath("/");
       try {
           InputStream in = null;
           ByteArrayOutputStream out = new ByteArrayOutputStream();
            //建一个空的字节数组
            byte[] result = null;
            in=new FileInputStream(realPath+"image/"+imageName);
           System.out.println(realPath+"image/"+imageName);
            byte[] buf = new byte[1024];

            //用来定义一个准备接收图片总长度的局部变量
            int len;
            //将流的内容读取到buf内存中
            while ((len = in.read(buf)) > 0) {
                //将buf内存中的内容从0开始到总长度输出出去
                out.write(buf, 0, len);
            }
            //将out中的流内容拷贝到一开始定义的字节数组中
            result = out.toByteArray();
            //通过util包中的Base64类对字节数组进行base64编码
             base64 = Base64.getEncoder().encodeToString(result);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return base64;
    }


}
