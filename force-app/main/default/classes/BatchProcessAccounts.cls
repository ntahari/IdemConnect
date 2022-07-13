global class BatchProcessAccounts implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext info){ 
        //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
        Set<Id> taskWhatIDs = new Set<Id>();
        for (Task t : [SELECT WhatId FROM Task WHERE What.type = 'Account'
                       AND Subject != 'Call']) {
            taskWhatIDs.add(t.whatId);
        }
        return Database.getQueryLocator([SELECT Id, OwnerId FROM Account 
                                        WHERE Id NOT IN (SELECT AccountId FROM Order) 
                                        AND Id NOT IN :taskWhatIDs]);
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){
        // Create Task for every account of list scope
        TaskUtilies.CreateTask(scope);
    }   
    global void finish(Database.BatchableContext info){     
    } 
}
