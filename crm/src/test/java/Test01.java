import java.io.File;
import java.io.IOException;

public class Test01 {
    public static void main(String[] args) throws IOException {
        File file=new File("D:/wb/ooooooooo.txt");
        file.createNewFile();
    }
}
