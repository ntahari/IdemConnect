/**
 * TestDataFactory methods to insert data in bdd
 *
 * @author rbatti14@mindful-fox-esxfvh.com
 * @version Version number
 */
@isTest
public class TestDataFactory{
    static final Id PRICEBOOK2ID = Test.getStandardPricebookId();

    public static User createUser(String ProfileName) {
        //get a profile Id
        Profile prof = [SELECT Id FROM Profile WHERE Name = :ProfileName];

        User testUser = new User(Alias = 'TDemo', Email = 'rbatti14@hotmail.fr', 
        EmailEncodingKey = 'ISO-8859-1', FirstName = 'Demo', LanguageLocaleKey = 'fr_FR', 
        LastName = 'User', LocaleSidKey = 'fr_FR', ProfileId = prof.Id, 
        TimeZoneSidKey = 'Europe/Paris', Username = 'demo.rbatti14@hotmail.fr'); 
        return testUser;
    }


    // Create list of Accounts with their orders 
    public static List<Account> createAccountsWithOrders(Integer numAccts, Integer numOrdersPerAcct){
        //Add Acounts
        List<Account> accts = createAccounts(numAccts);
        // Add Orders with shipmentCost = 100
        List<Order> orders = createOrders(accts, numOrdersPerAcct, 100);
        // Add OrderItem with quantity of item = 10 AND price unity = 150 and Update Orders
        createOrderItem(orders, 10, 150);
        return accts;
    }

    // Create Accounts
    public static List<Account> createAccounts(Integer numAccts){
        List<Account> accts = new List<Account>();
        for (Integer i = 0; i < numAccts; i++){
            Account a = new Account(Name = 'TestAccount' + i);
            accts.add(a);
        }
        insert accts;
        return accts;
    }

    //Create Orders
    public static List<Order> createOrders(List<Account> accts, Integer numOfOrders, Integer shipmentCost){
        List<Order> orders = new List<Order>();
        // For each account just inserted, add contract
        List<Contract> cons = creatContract(accts);
        
        for (Integer i = 0; i < accts.size(); i++){
            Account acct = accts[i];
            for (Integer k = 0; k < cons.size(); k++) {
                Contract con = cons[i];
            
                // For each account just inserted, add orders
                for (Integer j = 0; j < numOfOrders; j++){
                    orders.add(new Order(AccountId = acct.Id, ContractId = con.Id, EffectiveDate = System.today(), Status = 'Draft', ShipmentCost__c = ShipmentCost, Pricebook2Id = PRICEBOOK2ID));
                }
            }
        }
        // Insert all orders for all accounts.
        insert orders;
        return orders;
    }

    // create order Item
    public static void createOrderItem(List<Order> orders, Integer quantity, Integer unitPrice){
        PricebookEntry pbe = creatProduct(1020);
        List<OrderItem> ordersIt = new List<OrderItem>();
        for (Integer i = 0; i < orders.size(); i++){
            Order ord = orders[i];
            //ord.Status = 'Ordered';
            // Create an order item
            ordersIt.add(new OrderItem(OrderId = ord.Id, PricebookEntryId = pbe.Id, Quantity = quantity, UnitPrice = unitPrice));
        }
        insert ordersIt;
        update orders;
    }

    // Create a product with PricebookEntry
    public static PricebookEntry creatProduct(Integer unitPrice){
        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        insert pd1;
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = PRICEBOOK2ID, Product2Id = pd1.Id, UnitPrice = unitPrice, IsActive = true);
        insert pbe;
        return pbe;
    }
    // Create Contract for each account
    private static List<Contract> creatContract(List<Account> accts) {
        List<Contract> cons = new List<Contract>();
        for (Integer i=0;i<accts.size();i++) {
            Account acct = accts[i];

            // For each account just inserted, add contract
            cons.add(new Contract(
                AccountId = acct.Id,
                Status = 'Draft',
                StartDate = System.today(),
                ContractTerm = 3
            ));
        }
        insert cons;
        //update contract's statu
        for (Integer j = 0; j < cons.size(); j++) {
            Contract con = cons[j];
            con.Status = 'Activated';
        }
        update cons;
        return cons;
    }

}