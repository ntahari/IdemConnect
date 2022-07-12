/**
 * TaskUtilies Description
 *
 * @author rbatti14@mindful-fox-esxfvh.com
 * @version Version number
 */
public with sharing class TaskUtilies {
    /**
     * CreateTask create list of tasks and inert them to Bdd
     *
     * @param acctsList (List<Account>):
     *
     * @return List<Task>: Tasks with status "nouvelle"
     *
     */
    public static List<Task> CreateTask(List<Account> acctsList) {
        List<Task> tskList = new List<Task>();
        for (Account acc : acctsList) {
                Task tsk = new Task();
                tsk.Subject = 'Call';
                tsk.Status = 'Nouvelle';
                tsk.Priority = 'Normal';
                tsk.Description = 'Rappel pour contacter le client';
                tsk.WhatId = acc.Id;
                tsk.OwnerId= acc.OwnerId;
                tsk.IsReminderSet = true;
                tsk.ReminderDateTime = Date.today()+5;
                tskList.add(tsk);
        }
        if (tskList.size() > 0) {
            insert tskList;
            System.debug('tache createTask: '+ tskList);
        }
        return tskList;
    }
}
