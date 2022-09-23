import java.util.UUID;

class User {
    String name;
}
public class Test {
    public static void main(String[] args) {
        UUID uuid = UUID.randomUUID();
        System.out.println(uuid.toString().replace("-",""));

    }
}
