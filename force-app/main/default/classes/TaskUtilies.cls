public with sharing class TaskUtilies {
    public static List<Task> CreateTask(List<Account> acctsList) {
        System.debug(LoggingLevel.INFO, '== scopeList size ==' + acctsList.size());
        List<Task> tskList = new List<Task>();
        for (Integer i = 0; i < acctsList.size(); i++) {
            Account acct = acctsList[i];
            if (acct.Tasks.size() == 0) {
                Task tsk = new Task();
                tsk.Subject = 'Call';
                tsk.Status = 'Nouvelle';
                tsk.Priority = 'Normal';
                tsk.WhatId = acct.ID;
                tsk.IsReminderSet = true;
                tsk.ReminderDateTime = Date.today()+5;
                tskList.add(tsk);
            }
        }
        if (tskList.size() > 0) {
            insert tskList;
        }
        return tskList;
    }
}
