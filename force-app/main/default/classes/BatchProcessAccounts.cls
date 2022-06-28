global class BatchProcessAccounts implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext info){ 
        //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
         return Database.getQueryLocator(QueriesService.AccountsWithoutTasks());
 
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){
        System.debug('>>> Account with not orders no tasks: ' + scope);
        System.debug(LoggingLevel.INFO, '== scopeList size ==' + scope.size());
        List<Task> tskList = new List<Task>();
        for (Integer i = 0; i < scope.size(); i++) {
            Account acct = scope[i];
            Task tsk = new Task();
            tsk.Subject = 'Call';
			tsk.Status = 'Nouvelle';
			tsk.Priority = 'Normal';
			tsk.WhatId = acct.ID;
			tskList.add(tsk);
        }
        //insert tskList;
        
        
        //Set<Id> setAccountIds = (new Map<Id,SObject>(scope)).keySet();
    }    
     
    global void finish(Database.BatchableContext info){     
        
    } 
}
