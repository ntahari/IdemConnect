@isTest
public with sharing class TestBatchProcess {
    @IsTest
    static void taskReminderToAccountWithNoOrder(){
        TestDataFactory.createAccounts(1);
        List<Account> accts = [SELECT Id, OwnerId FROM Account];
        
        Test.startTest();
        BatchProcessAccounts batch = new BatchProcessAccounts();
        Database.executeBatch(batch);
        Test.stopTest();
        
        Task tsk = [SELECT Status, WhatId FROM Task WHERE WhatId = :accts[0].Id];
        // verify Account have 0 orders
        System.assertEquals(0, accts[0].Orders.size());
        System.assertNotEquals(null, tsk);
        // verify Account have task with status nouvelle
        System.assertEquals('Nouvelle', tsk.Status);

    }
}
