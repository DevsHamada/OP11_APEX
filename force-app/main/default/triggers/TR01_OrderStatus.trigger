trigger TR01_OrderStatus on Order(before update , after delete){

    if (trigger.isBefore && trigger.isUpdate){
    AP01_OrderProductChecker.checkProducts(trigger.newMap , trigger.oldMap);
}
    if (Trigger.isAfter && Trigger.isDelete){
AP01_OrderProductChecker.handleOrderDeletion(trigger.old);
 }
}