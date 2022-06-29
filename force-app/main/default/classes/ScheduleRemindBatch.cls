global class ScheduleRemindBatch implements Schedulable {
    global void execute(SchedulableContext sc) {
        BatchProcessAccounts batch = new BatchProcessAccounts(); 
        database.executebatch(batch);
     }
}
