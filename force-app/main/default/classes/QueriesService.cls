public with sharing class QueriesService {
    public static String AccountsWithoutTasks() {
        String query = 'SELECT Id, OwnerId,';
               query+= '(SELECT Id FROM Tasks Where Type = \'Call\')';
               query+= 'FROM Account WHERE Id NOT IN (SELECT AccountId FROM Order)';
        return query; 
    }
    public static List<Account> AccountsWithOrders(Set<Id> setAccountIds) {
        List<Account> accts = [
        SELECT Id, (SELECT Id FROM Orders ) 
        FROM Account WHERE Id IN :setAccountIds];
        return accts;
    }
}
