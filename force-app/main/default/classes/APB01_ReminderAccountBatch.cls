global class APB01_ReminderAccountBatch implements  Database.Batchable<sObject>{
    
    public String query;
    // Query to retrieve accounts without orders and without "Call" reminder tasks
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT OwnerId, (SELECT Id FROM Orders), (SELECT Id FROM Tasks WHERE Subject=\'Call\') FROM Account';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
         List<Task> tasksToInsert = new List<Task>();
        for ( Account acc : scope){
            // Creating a reminder task for each retrieved account
            if(acc.Orders.size() == 0 && acc.Tasks.size() == 0){
            Task t = new Task();
            t.Subject = 'Call';
            t.Priority = 'Normal';
            t.Status = 'New';
            t.OwnerId = acc.OwnerId;
            t.WhatId = acc.Id;
            t.ActivityDate = System.today() + 5; // Automatic reminder in one week
            tasksToInsert.add(t);
        }
    }
        // Inserting the tasks into the database
        insert tasksToInsert;
    }
    
    global void finish(Database.BatchableContext BC){
         // Sending a notification email to the platform administrator
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] { 'mohamed.zejli@gmail.com' };
        mail.setToAddresses(toAddresses);
        mail.setSubject('Reminder tasks created successfully');
        mail.setPlainTextBody('The reminder tasks have been created successfully for accounts without orders and without reminder tasks.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }
}