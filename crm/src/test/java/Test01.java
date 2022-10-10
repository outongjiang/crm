import java.io.File;
import java.io.IOException;
import java.util.ResourceBundle;

public class Test01 {
    public static void main(String[] args) throws IOException {
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String tran = bundle.getString("成交");
        System.out.println(tran);
    }
}
