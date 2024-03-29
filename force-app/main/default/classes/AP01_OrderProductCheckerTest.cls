@isTest
private class AP01_OrderProductCheckerTest {
    static Integer NUM_OF_ACCOUNTS = 1;
    static Integer NUM_OF_ORDERS = 1;

    /**
     * Create test data by inserting one account and one order.
     */
    @testSetup
    static void setupTestData() {
        TestDataFactory.insertData(NUM_OF_ACCOUNTS, NUM_OF_ORDERS);
    }
    
        // Test method to check orders without products
        @isTest
        static void testCheckProducts_NoProducts() {
            
            // Change the status of the orders to 'Activated' and delete the order items
            List<Order> orders = [SELECT Id, Status, (SELECT Id FROM OrderItems) FROM Order];
            List<OrderItem> orderItemsToDelete = new List<OrderItem>();
            List<Order> odrToUpd = new List<Order>();
                    
            for (Order order : orders) {
                for (OrderItem orderItem : order.OrderItems) {
                    orderItemsToDelete.add(orderItem);
                }
                odrToUpd.add(order);
            }
            // Delete the order items
                delete orderItemsToDelete;
    
            // Update the orders and expect an exception if there are no products
            Test.startTest();
            try {
              update odrToUpd;
            } catch (Exception e) {
                // Check if the exception message contains the expected error message
                Boolean ExceptionError =  e.getMessage().contains('L\'order doit avoir au moins un produit avant d\'être activé.') ? true : false; 
                System.assertEquals(ExceptionError, true);
            }
            Test.stopTest();
    
            // Verify that the status of the orders without products is still 'Draft'
            orders = [SELECT Status, (SELECT Id FROM OrderItems) FROM Order];
            for(Order order : orders){
                System.assertEquals('Draft', orders.Status);
            }
        }
    
        // Test method to check orders with products
        @isTest
        static void testCheckProducts_WithProducts() {
            // Change the status of the orders to 'Activated' without deleting any order items
            List<Order> orders = [SELECT Id, Status, (SELECT Id FROM OrderItems) FROM Order];
                    
            for(Order order : orders){
                order.Status = 'Activated';
            }
                    
            // Update the orders and expect no exception since there are products
            Test.startTest();
            try {
              update orders;
            } catch (Exception e) {
                // Check if the exception message contains the expected error message
                Boolean ExceptionError =  e.getMessage().contains('L\'order doit avoir au moins un produit avant d\'être activé.') ? true : false; 
                System.assertEquals(ExceptionError, false);
                System.debug(ExceptionError);
            }
            Test.stopTest();
    
            // Verify that the status of the orders with products is 'Activated'
            orders = [SELECT Id, Status, (SELECT Id FROM OrderItems) FROM Order];
            for(Order order : orders){
                System.assertEquals('Activated', updatedOrder.Status);
            }
        }
        @isTest
        static void testActiveFlagOnAccountWhenOrderDeleted() {
            // Create test data by inserting one account and one order
            List<Order> listOrders = TestDataFactory.insertData(NUM_OF_ACCOUNTS, NUM_OF_ORDERS);

            
            // Check that the account is active before the order is deleted
            Account updatedAccount = [SELECT Active__c FROM Account WHERE Id = :listOrders[0].AccountId  ];
            System.assertEquals(true, updatedAccount.Active__c);
        
            // Call the method to check orders with products
            Test.startTest();
            delete listOrders;
            Test.stopTest();
        
            // Verify that the account is inactive after the order is deleted
            updatedAccount = [SELECT Active__c FROM Account WHERE Id= :listOrders[0].AccountId ];
            System.assertEquals(false, updatedAccount.Active__c);
        }
        
        @isTest
        static void testActiveFlagOnAccountWithOrder() {
            // Create test data with an order that will be deleted
            List<Order> listOrdersdelete =TestDataFactory.insertData(NUM_OF_ACCOUNTS, NUM_OF_ORDERS);

            // Create test data with an order that will not be deleted            
            List<Order> listOrdersNoDelete =TestDataFactory.insertData(NUM_OF_ACCOUNTS, NUM_OF_ORDERS);

        
            // Check that the account is active when it has an order
            Account updatedAccountWithOrder = [SELECT Active__c FROM Account WHERE Id = :listOrdersNoDelete[0].AccountId  ];
            System.assertEquals(true, updatedAccountWithOrder.Active__c);
            
            // Check that the account is active when it has no orders
            Account updatedAccountWithoutOrder = [SELECT Active__c FROM Account WHERE Id = :listOrdersdelete[0].AccountId  ];
            System.assertEquals(true, updatedAccountWithoutOrder.Active__c);
        
            // Call the method to delete the order
            Test.startTest();
            delete listOrdersdelete;
            Test.stopTest();
        
            // Verify that the account is inactive after the order is deleted
            updatedAccountWithoutOrder = [SELECT Active__c FROM Account WHERE Id= :listOrdersdelete[0].AccountId ];
            System.assertEquals(false, updatedAccountWithoutOrder.Active__c);
        
            // Verify that the account is still active after the other order is deleted
            updatedAccountWithOrder = [SELECT Active__c FROM Account WHERE Id  = :listOrdersNoDelete[0].AccountId  ];
            System.assertEquals(true, updatedAccountWithOrder.Active__c);
        }
        
}
