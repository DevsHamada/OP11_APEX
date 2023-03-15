public class AP01_OrderProductChecker {
    public static void checkProducts(List<Order> newOrders, Map<Id, Order> oldOrders) {
        for (Order newOrder : newOrders) {
            // récupérer l'objet Order correspondant à la nouvelle commande dans la carte oldOrders
            Order oldOrder = oldOrders.get(newOrder.Id);
            if (newOrder.Status == 'Activated' && oldOrder.Status == 'Draft') {
                List<OrderItem> items = [SELECT Id FROM OrderItem WHERE OrderId = :newOrder.Id];
                if (items.isEmpty()) {
                    newOrder.addError('L\'order doit avoir au moins un produit avant d\'être activé.');
                }
            }
    }
}
    public static void handleOrderDeletion(List<Order> deletedOrders) {
        Set<Id> accountIds = new Set<Id>();
        for (Order o : deletedOrders) {
            accountIds.add(o.AccountId);
        }

        Account accountsToUpdate = new Account();
        for (Id accountId : accountIds) {
             accountsToUpdate = [SELECT Active__c, (SELECT Id FROM Orders WHERE AccountId =: accountId) FROM Account WHERE Id = :accountId ];
            if (accountsToUpdate.Orders.isEmpty()) {
                accountsToUpdate.active__c = false;
                update accountsToUpdate;
            }
        }


    }
}