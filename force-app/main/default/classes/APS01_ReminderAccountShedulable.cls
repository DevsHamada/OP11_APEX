global class APS01_ReminderAccountShedulable  implements Schedulable{
    global void execute(SchedulableContext sc) {
        APB01_ReminderAccountBatch batch = new APB01_ReminderAccountBatch();
        Database.executeBatch(batch);    
    }
}