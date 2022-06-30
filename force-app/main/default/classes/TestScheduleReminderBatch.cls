@IsTest
private class TestScheduleReminderBatch {
	//CRON_EXP is the next time this schedule will run
	public static String CRON_EXP = '0 0 12 ? 1/1 MON#1 *';

	@TestSetup
	static void setUpPerTest() {
		List<Account> acct = TestDataFactory.createAccounts(10);
	}
	/**
     * @description test the Scheduled Job
     */
	@IsTest
	static void testScheduledJob() {

		Test.startTest();

		String jobId = System.schedule('ScheduleApexTest',CRON_EXP,new ScheduleReminderBatch());
		Test.stopTest();

		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime,CronJobDetailId,State 
						  FROM CronTrigger WHERE id = :jobId];
		
		System.assertEquals(CRON_EXP, ct.CronExpression);
		System.assertEquals(0, ct.TimesTriggered);
		System.debug('>>CronTrigger timesTriggered>> '+ct.TimesTriggered);
		System.debug('>>CronTrigger next time>> '+ct.NextFireTime);
		System.debug('>>CronTrigger state>> '+ct.State);

		// Stopping the test will run the job synchronously
		List<Task> taskList = [SELECT Status, Subject, WhatId FROM Task 
							WHERE WhatId IN (SELECT Id FROM Account) 
							AND Status = 'Nouvelle'];

		System.debug('>> list des tasks >> '+ taskList.size());

	}
}