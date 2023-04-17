public with sharing class JunctionTriggerHandler {

    public static void beforeInsert(List<Junction__C> newList) {
    }
    
    public static void afterInsert(List<Junction__C> newList) {
        updateRelatedParent(newList, NULL);
    }
    
    public static void beforeUpdate(List<Junction__C> newList, Map<Id, Junction__C> oldMap) {
    }
    
    public static void afterUpdate(List<Junction__C> newList, Map<Id, Junction__C> oldMap) {
        updateRelatedParent(newList, oldMap);
    }
    
    public static void beforeDelete(List<Junction__C> oldList) {
    }
    
    public static void afterDelete(List<Junction__C> oldList) {
    }

    private static void updateRelatedParent(List<Junction__c> junctionRecords, Map<Id, Junction__c> junctionMap) {
        
        List<ParentTwo__c> parentTwoData = new List<ParentTwo__c>();
        
        Map<Id,Junction__c> junctionParentsData = new Map<Id,Junction__c>([SELECT Id, Name, ParentOne__c, ParentOne__r.Start_Date__c, ParentTwo__c, ParentTwo__r.Start_Date__c FROM Junction__c]);

        for (Junction__c junction : junctionRecords) {
            if ( junctionMap == NULL 
                || (junction.ParentOne__c != NULL 
                && junctionMap.get(junction.Id).ParentOne__c != junction.ParentOne__c )) {
                    
                Junction__c queryData = junctionParentsData.get(junction.Id);

                if (queryData.ParentOne__r.Start_Date__c != Null) {
                    parentTwoData.add(new ParentTwo__c ( Id = junction.ParentTwo__c, Start_Date__c = (Date)queryData.ParentOne__r.Start_Date__c));
                }

            }
        }

        if (!parentTwoData.isEmpty()) {
            update parentTwoData;
        }

    }
    
}