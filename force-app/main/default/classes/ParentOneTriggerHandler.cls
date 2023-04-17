public with sharing class ParentOneTriggerHandler{
    public static void beforeInsert(List<ParentOne__c> newList){
    }

    public static void afterInsert(List<ParentOne__c> newList){
    }

    public static void beforeUpdate(List<ParentOne__c> newList, Map<Id, ParentOne__c> oldMap){
    }

    public static void afterUpdate(List<ParentOne__c> newList, Map<Id, ParentOne__c> oldMap){
        updateRelatedSiblingParent(newList, oldMap);
    }

    public static void beforeDelete(List<ParentOne__c> oldList){
    }

    public static void afterDelete(List<ParentOne__c> oldList){
    }

    private static void updateRelatedSiblingParent(List<ParentOne__c> parentOneRecords, Map<Id, ParentOne__c> parentOneMap){

        List<Junction__c> junction = [SELECT Id, Name, ParentOne__c, ParentTwo__c
                                      FROM Junction__c];

        Map<Id, Id> siblingParentIds = new Map<Id, Id>();
        List<ParentTwo__c> updatedParentRecords = new List<ParentTwo__c>();

        for (junction__c jun : junction){
            siblingParentIds.put(jun.ParentOne__c, jun.ParentTwo__c);
        }

        for (ParentOne__c ParentOneRecord : parentOneRecords){
            if (parentOneRecord.Start_Date__c != NULL && parentOneRecord.Start_Date__c != parentOneMap.get(ParentOneRecord.Id).Start_Date__c){
                updatedParentRecords.add(new ParentTwo__c(Id = siblingParentIds.get(ParentOneRecord.Id), Start_Date__c = parentOneRecord.Start_Date__c));
            }
        }

        if (!updatedParentRecords.isEmpty()){
            update updatedParentRecords;
        }
    }

}