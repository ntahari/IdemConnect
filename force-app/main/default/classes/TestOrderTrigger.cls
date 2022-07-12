@isTest
private with sharing class TestOrderTrigger {
    static List<Order> orders = new List<Order>();
    static List<Account> accts = new List<Account>();
    @TestSetup
    static void setUpPerTest(){
        // create account before each test
        accts = TestDataFactory.createAccounts(1);
        // create order before each test
        orders= TestDataFactory.createOrders(accts, 1, 10);
    }
    @IsTest
    static void activateOrderStatusTest(){
        orders = [SELECT Status, (SELECT Id FROM OrderItems) FROM Order]; 
        orders[0].Status = 'Activated';
        Test.startTest();
        // update order 
        Database.SaveResult[] updateResult = Database.update(orders, false);
        Test.stopTest();
        // get errors from orders updated
        for (Database.SaveResult r : updateResult) {
            System.assert(!r.isSuccess());
            System.assert(r.getErrors().size() > 0);
            System.assertEquals('Impossible d activer le status sans produit !',
                                r.getErrors()[0].getMessage());
        }
        // Verify that Order have 0 items
        System.assertEquals(0, orders[0].OrderItems.size());
    }

    @IsTest
    static void uncheckedActivatedBoxTest(){
        Account acct = [SELECT Active__c, (SELECT Id FROM Orders) FROM Account];
        acct.Active__c = true;
        Order ord = acct.orders[0];
        Test.startTest();
        update acct;
        delete ord;
        Test.stopTest();

        Account acctupdated = [SELECT Active__c, (SELECT Id FROM Orders) FROM Account];
        // verify that account have 0 order
        System.assertEquals(0, acctupdated.Orders.size());
        // verify that active's field' is unchecked
        System.assertEquals(false, acctupdated.Active__c);
        
    }
}
