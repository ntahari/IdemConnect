global class ScheduleReminderBatch implements Schedulable {
    global void execute(SchedulableContext sc) {
        BatchProcessAccounts batch = new BatchProcessAccounts(); 
        database.executebatch(batch);
     }
     Public static void SchedulerMethod() {
         string con_exp= '0 0 12 ? 1/1 MON#1 *';
         System.schedule('RunBatchProcessAccount', con_exp, new ScheduleReminderBatch());
     }
}
