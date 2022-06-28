public with sharing class QueriesService {
    public static String AccountsWithoutTasks() {
        // Create a set of Accounts with no Tasks and no orders
        List<Task> ts = [
            SELECT Id, WhatId FROM Task
            WHERE what.type = 'Account'];
        Set<Id> accountsIdsWithTask = new Set<Id>();
        for (Integer i = 0; i < ts.size(); i++) {
            accountsIdsWithTask.add(ts[i].WhatId);
        }
        List<Account> accts = [
            SELECT Id FROM Account 
            WHERE Id NOT IN :accountsIdsWithTask
            AND Id NOT IN (SELECT AccountId FROM Order)];
        
        return 'SELECT Id FROM Account WHERE Id NOT IN \'accountsIdsWithTask\' AND Id NOT IN (SELECT AccountId FROM Order)'; 
    }
    public static List<Account> AccountsWithOrders(Set<Id> setAccountIds) {
        List<Account> accts = [
        SELECT Id, (SELECT Id FROM Orders ) 
        FROM Account WHERE Id IN :setAccountIds];
        return accts;
    }
}
