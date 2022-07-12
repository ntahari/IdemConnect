/**
 * OrderTriggerHandler Description
 *
 * @author rbatti14@mindful-fox-esxfvh.com
 * @version Version number
 */
public with sharing class OrderTriggerHandler {
    /**
     * ActivateOrderStatus Trigger an error if activate order's status with no product
     *
     * @param newOrders (List<Order>): new orders from trigger
     * @param oldOrders (List<Order>): old orders from trigger
     * @throws Class OrderTriggerHandler 
     */
    public static void ActivateOrderStatus(List<Order> newOrders, List<Order> oldOrders) {
        // get Old Orders with Products
        oldOrders = QueriesService.FindOrders(newOrders);
        for(integer i=0; i< newOrders.size(); i++){
            if (newOrders[i].Status == 'Activated' && oldOrders[i].status !='Activated' ) {
                if (oldOrders[i].OrderItems.size() == 0) {
                    newOrders[i].addError('Impossible d activer le status sans produit !');
                }
            }
        }
    }
    /**
     * UncheckedActivatedBox uncheck active field from account if delete all orders
     *
     * @param oldOrders (List<Order>): old orders from trigger
     *
     *
     * @throws Class name here Write the class description
     */
    public static void UncheckedActivatedBox(List<Order> oldOrders) {
        // update acctsToUpdate;
        set<Id> setAccountIds = new set<Id>();
        for (Order  ord : oldOrders) {
            setAccountIds.add(ord.AccountId);
        }
        // get accounts + orders
        List<Account> acctList = QueriesService.AccountsWithOrders(setAccountIds);
        List<Account> acctsToUpdate = new List<Account>();
        for (Account acc : acctList) {
            if (acc.Orders.size() == 0) {
                acc.Active__c = false;
                acctsToUpdate.add(acc);
            }
        }
        update acctsToUpdate;
    }
    /**
     * CheckAccountsActiveField Description
     *
     * @param newOrder (List<Order>): new orders from trigger
     *
     *
     * @throws Class OrderTriggerHandler
     */
    public static void CheckAccountsActiveField(List<Order> newOrder) {
        List<Account> acctsOrder = QueriesService.FindAcctsByOrders(newOrder);
        List<Account> acctsToUpdate = new List<Account>();
        for (Integer i = 0; i < acctsOrder.size(); i++) {
            acctsOrder[i].Active__c = true;
            acctsToUpdate.add(acctsOrder[i]);
        }
        update acctsToUpdate;
    }
}
