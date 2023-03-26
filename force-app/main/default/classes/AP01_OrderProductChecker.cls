public class AP01_OrderProductChecker {
    public static void checkProducts(Map<Id, Order> newOrders, Map<Id, Order> oldOrders) {
        List<Order> items = [SELECT Status, (SELECT Id FROM OrderItems) FROM Order WHERE Id IN :newOrders.keySet()];
        for (Order newOrder : items) {
            // récupérer l'objet Order correspondant à la nouvelle commande dans la carte oldOrders
            Order oldOrder = oldOrders.get(newOrder.Id);
            if (newOrder.Status == 'Activated' && oldOrder.Status == 'Draft') {
                if (newOrder.OrderItems.size() == 0 ) {
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
        List<Account> accountsToUpdate = [SELECT Id, Active__c, (SELECT Id FROM Orders WHERE AccountId =: accountIds) FROM Account WHERE Id IN :accountIds];
        for (Account acc : accountsToUpdate) {
            if (acc.Orders.isEmpty()) {
                acc.active__c = false;
            } else {
                acc.active__c = true;
            }
        }
        update accountsToUpdate;

    }
}