public with sharing class PositionTriggerHandler {
    public static void beforeInsert(List<Position__c> newList) {
        defaultPositionFieldValues(newList);
    }
    
    public static void afterInsert(List<Position__c> newList) {
        
    }
    
    public static void beforeUpdate(List<Position__c> newList, Map<Id, Position__c> oldMap) {
        
    }
    
    public static void afterUpdate(List<Position__c> newList, Map<Id, Position__c> oldMap) {

    }
    
    public static void beforeDelete(List<Position__c> oldList) {
        
    }
    
    public static void afterDelete(List<Position__c> oldList) {
        
    }

    private static void defaultPositionFieldValues(List<Position__c> newPosition){
        for(Position__c position : newPosition) {
           if (position.openDate__c == NULL && position.maximumPay__c == NULL && position.minimumPay__c == NULL) {
                position.openDate__c = Date.Today();
                position.maximumPay__c = 15000;
                position.minimumPay__c = 10000;
           }
        }
    }
}