@isTest
private class  APB01_ReminderAccountBatchTest {
    static testMethod void testBatchJob()  {
        // Create test accounts without orders and reminder tasks
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            Account acc = new Account(Name = 'Test Account ' + i, Industry = 'Technology', Phone = '123-456-7890', Website = 'www.example.com');
            accounts.add(acc);
        }
        insert accounts;
        
        // Run the batch job
        Test.startTest();
        Database.executeBatch(new APB01_ReminderAccountBatch());
        Test.stopTest();
        
        // Check that reminder tasks have been created for accounts without orders and reminder tasks
        List<Task> tasks = [SELECT Id FROM Task WHERE Subject = 'Call'];
        System.assertEquals(200, tasks.size());

    }
}