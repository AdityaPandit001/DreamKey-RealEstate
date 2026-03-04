public class ForInvocablePurpose {
    
    @InvocableMethod()
    public static void createAccount() {
        Account acc = new Account();
        acc.Name = 'Via Invocable Method';
        insert acc;
    }

}