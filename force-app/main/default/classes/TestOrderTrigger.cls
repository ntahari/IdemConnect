@isTest
private with sharing class TestOrderTrigger {
    static List<Order> orders = new List<Order>();
    static List<Account> accts = new List<Account>();
    @TestSetup
    static void makeData(){
        accts = TestDataFactory.createAccounts(1);
        orders= TestDataFactory.createOrders(accts, 1, 10);
    }
    @IsTest
    static void ActivateOrderStatusTest(){
        orders = [SELECT Status, (SELECT Id FROM OrderItems) FROM Order]; 
        orders[0].Status = 'Activated';
        Test.startTest();
        Database.SaveResult[] updateResult = Database.update(orders, false);
        Test.stopTest();
        for (Database.SaveResult r : updateResult) {
            System.assert(!r.isSuccess());
            System.assert(r.getErrors().size() > 0);
            System.assertEquals('Cannot activate order without product !',
                                r.getErrors()[0].getMessage());
        }
        // Verify that Order have 0 items
        System.assertEquals(0, orders[0].OrderItems.size());
    }

    @IsTest
    static void UncheckedActivatedBoxTest(){
        Account acct = [SELECT Active__c, (SELECT Id FROM Orders) FROM Account];
        acct.Active__c = true;
        Order ord = acct.orders[0];
        System.debug('>>>order: '+ord);
        Test.startTest();
        update acct;
        delete ord;
        Test.stopTest();
        System.debug('>>> acount active: '+ acct.Orders);
        //System.assertEquals(0, acct.Orders.size());
        System.assertEquals(false, acct.Active__c);
        
    }
}
