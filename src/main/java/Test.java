class User {
    String name;
}
public class Test {
    public static void main(String[] args) {
            User u=new User();
            u.name="11";
            User u2=u;
        System.out.println("u2.name : "+u2.name);
        System.out.println("u2 : "+u2);
        System.out.println("u : "+u);

    }
}
