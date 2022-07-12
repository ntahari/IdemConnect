public with sharing class QueriesService {
    // Get list of account with at least one order
    public static List<Account> FindAcctsByOrders(List<Order> orders) {
        List<Account> accts =[SELECT Active__c,(SELECT Id FROM Orders) FROM Account 
                            WHERE Id IN (SELECT AccountId FROM Order WHERE Id IN :orders)];
        return accts;
    }
    // get orders 
    public static List<Order> FindOrders(List<Order> orders) {
        List<Order> ordersList = [SELECT status, (SELECT Id FROM OrderItems) FROM Order WHERE Id IN :orders];
        return ordersList;
    }
    public static List<Account> AccountsWithOrders(Set<Id> setAccountIds) {
        List<Account> accts = [
        SELECT Id, (SELECT Id FROM Orders ) 
        FROM Account WHERE Id IN :setAccountIds];
        return accts;
    }
}
