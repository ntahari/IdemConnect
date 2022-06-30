global class BatchProcessAccounts implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext info){ 
        //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
         return Database.getQueryLocator(QueriesService.AccountsWithoutTasks());
 
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){
        TaskUtilies.CreateTask(scope);
    }   
     
    global void finish(Database.BatchableContext info){     
        
    } 
}
