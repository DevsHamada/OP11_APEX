@isTest(seeAllData=false)
private class APB01_ReminderAccountSchedulerTest {
    static testMethod void scheduleJob() {
        Test.startTest();
         System.schedule('APB01 Reminder Account Batch', '0 0 0 1-7 * ? *', new APS01_ReminderAccountShedulable());
        Test.stopTest();
        List<CronTrigger> cronTriggers = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'APB01 Reminder Account Batch'];
        System.assertEquals(1, cronTriggers.size());
    }
}