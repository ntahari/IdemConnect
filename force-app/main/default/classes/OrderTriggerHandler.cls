public with sharing class OrderTriggerHandler {
    public static void ActivateOrderStatus(List<Order> newOrders, List<Order> oldOrders) {
        // get Old Orders with Products
        oldOrders = [SELECT status, (SELECT Id FROM OrderItems) FROM Order WHERE Id IN :newOrders];
        System.debug('old orders active Order: '+ oldOrders);
        for(integer i=0; i< newOrders.size(); i++){
            if (newOrders[i].Status == 'Activated' && oldOrders[i].status !='Activated' ) {
                if (oldOrders[i].OrderItems.size() == 0) {
                    newOrders[i].addError('Cannot activate order without product !');
                }
            }
        }
    }
    
    public static void UncheckedActivatedBox(List<Order> oldOrders) {
        set<Id> setAccountIds = new set<Id>();
        for(integer i=0; i< oldOrders.size(); i++){
            Order Order = oldOrders[i];
            setAccountIds.add(order.AccountId);
        }
        // get accounts + orders
        List<Account> accts = QueriesService.AccountsWithOrders(setAccountIds);
        List<Account> acctsToUpdate = new List<Account>();
        for (Integer i = 0; i < accts.size(); i++) {
            Account acct = accts[i];
            if (acct.Orders.size() == 0) {
                acct.Active__c = false;
                acctsToUpdate.add(acct);
            }
        }
        update acctsToUpdate;
    }
}
