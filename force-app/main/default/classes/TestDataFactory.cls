public with sharing class TestDataFactory {
    public static final String INITIAL_ORDER_STATUS = 'Draft';
    public static final String FINAL_ORDER_STATUS = 'Activated';
    public static final Id STANDARD_PRICEBOOK_ID = Test.getStandardPricebookId();
    public static final Integer UNIT_PRICE = 100;
    public static final Integer ITEM_QUANTITY = 10;

        public static List<Account> createTestAccounts(Integer numOfAccounts) {
            List<Account> accounts = new List<Account>();
            for (Integer i = 0; i < numOfAccounts; i++) {
                Account a = new Account(Name='Test Account ' + i);
                accounts.add(a);
            }
            insert accounts;
            System.debug('hamada account : ' + accounts);
            return accounts;
        }
        public static Product2 createProducts(Integer numOfProducts) {
                Product2 products = new Product2(Family = 'Chemise', Name='Chemise Verte longue N°254');
            insert products;
            System.debug('hamada products : ' + products);

            return products;
        }
                // Construct a PricebookEntry record for unit tests
        public static PriceBookEntry createPricebookEntry(Product2 product) {
                    PricebookEntry pricebook = new PricebookEntry(Pricebook2Id = STANDARD_PRICEBOOK_ID,Product2Id = product.Id,UnitPrice = UNIT_PRICE,IsActive = true);
                    insert pricebook;
                    System.debug('hamada pricebook : ' + pricebook);

                    return pricebook;
        }
        public static List<Order> createOrdersForAccounts(List<Account> accounts, Integer nOrder) {
            List<Contract> contracts = new List<Contract>();
            List<Order> orders = new List<Order>();
            for (Account a : accounts) {
                Contract contract = new Contract(AccountId=a.id,Status='Draft',ContractTerm=5);
                contracts.add(contract);
                for (Integer i = 0; i < nOrder; i++) {
                Order o = new Order(AccountId=a.Id,Status=INITIAL_ORDER_STATUS , EffectiveDate = Date.Today(), Pricebook2Id = STANDARD_PRICEBOOK_ID, ContractId=contract.id);
                orders.add(o);
                 }
            }
            insert orders;
            System.debug('hamada orders : ' + orders);

            return orders;
        }
        public static List<OrderItem> createOrderItems(List<Order> orders, Product2 products, Pricebookentry priceBook) {
            List<OrderItem> orderItems = new List<OrderItem>();
            for (Order o : orders) {
                    OrderItem oi = new OrderItem(OrderId = o.Id, Product2Id = products.Id, PriceBookEntryId = priceBook.Id , Quantity = ITEM_QUANTITY, UnitPrice = priceBook.UnitPrice);
                    orderItems.add(oi);
            }
            insert orderItems;
            System.debug('hamada orderItems : ' + orderItems);

            return orderItems;
        }   

        public static List<Order> insertData(Integer numOfAccounts, Integer numOfOrders ) {

            List<Account> accounts = TestDataFactory.createTestAccounts(numOfAccounts);

            Product2 products = TestDataFactory.createProducts(numOfAccounts);

            PriceBookEntry PriceBookEntrys = TestDataFactory.createPricebookEntry(products);
            
            List<Order> listOrders = TestDataFactory.createOrdersForAccounts(accounts, numOfOrders);

            List<OrderItem> orderItems = TestDataFactory.createOrderItems(listOrders, products,PriceBookEntrys);
                      
            return listOrders;
        }

}