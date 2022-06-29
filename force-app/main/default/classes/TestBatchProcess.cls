@isTest
public with sharing class TestBatchProcess {
    @IsTest
    static void taskReminderToAccountWithNoOrder(){
        TestDataFactory.createAccounts(1);
        List<Account> accts = [SELECT Id FROM Account];
        
        Test.startTest();
        BatchProcessAccounts batch = new BatchProcessAccounts();
        Database.executeBatch(batch);
        Test.stopTest();
        
        Task tsk = [SELECT Status, WhatId FROM Task WHERE WhatId = :accts[0].Id];
        System.assertNotEquals(null, tsk);
        System.assertEquals('Nouvelle', tsk.Status);

    }
}
