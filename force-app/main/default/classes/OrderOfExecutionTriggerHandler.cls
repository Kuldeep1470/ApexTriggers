public class OrderOfExecutionTriggerHandler {
	public static void beforeInsert(List<order_of_execution__c> newList) {
        updateRelatedFieldBeforeInsert(newList);
    }
    
    public static void afterInsert(List<order_of_execution__c> newList) {
        updateRelatedFieldafterInsert(newList);
    }
    
    public static void beforeUpdate(List<order_of_execution__c> newList, Map<Id, order_of_execution__c> oldMap) {
        updateRelatedFieldBefore(newList, oldMap); 
    }

    public static void afterUpdate(List<order_of_execution__c> newList, Map<Id, order_of_execution__c> oldMap) {
        updateRelatedFieldafter(newList, oldMap);
    }
    
    public static void beforeDelete(List<order_of_execution__c> oldList) {
       
    }
    
    public static void afterDelete(List<order_of_execution__c> oldList) {
        
    }
    
    private static void updateRelatedFieldBeforeInsert(List<order_of_execution__c> orders){
        for(order_of_execution__c order : orders){
            if(order.run_before_trigger__c){
                order.Total_count__c += 1;
                order.order__c += ' before trigger Insert ';
            }
        }
    }
    
    private static void updateRelatedFieldBefore(List<order_of_execution__c> orders, Map<Id, order_of_execution__c> orderMap){
        for(order_of_execution__c order : orders){
            if(order.run_before_trigger__c 
               && orderMap.get(order.Id).order__c != order.order__c 
               && orderMap.get(order.Id).Total_count__c !=  order.Total_count__c ){
                order.Total_count__c += 1;
                order.order__c += ' before trigger update ';
            }
        }
    }
    
    private static void updateRelatedFieldafterInsert(List<order_of_execution__c> orders){
        List<order_of_execution__c> newOrders = new List<order_of_execution__c>();
        for(order_of_execution__c order : orders){
            if(order.run_after_trigger__c){
                order_of_execution__c newOrder = new order_of_execution__c();
                newOrder.Id = order.Id;
                if(newOrder.Total_count__c == NULL){
                    newOrder.Total_count__c = 1;
                }
                else{
                    newOrder.Total_count__c = order.Total_count__c + 1;
                }
                
                newOrder.order__c = order.order__c + ' after trigger Insert ';
                newOrders.add(newOrder);
            }
        }
        if(!newOrders.isEmpty()){
            update newOrders;
        }
    }
    
        
    private static void updateRelatedFieldafter(List<order_of_execution__c> orders, Map<Id, order_of_execution__c> orderMap){
        List<order_of_execution__c> newOrders = new List<order_of_execution__c>();
        for(order_of_execution__c order : orders){
            if(order.run_after_trigger__c 
               && orderMap.get(order.Id).order__c != order.order__c 
               && orderMap.get(order.Id).Total_count__c !=  order.Total_count__c ){
                order_of_execution__c newOrder = new order_of_execution__c();
                newOrder.Id = order.Id;
                if(newOrder.Total_count__c == NULL){
                    newOrder.Total_count__c = 1;
                }
                else{
                    newOrder.Total_count__c = order.Total_count__c + 1;
                }
                
                newOrder.order__c = order.order__c + ' after trigger update ';
                newOrders.add(newOrder);
            }
        }
        if(!newOrders.isEmpty()){
            update newOrders;
        }
    }
    
}