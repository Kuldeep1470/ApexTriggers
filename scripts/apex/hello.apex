List<Junction__c> junction= [SELECT Id, Name, ParentOne__c, ParentOne__r.Start_Date__c, ParentTwo__c, ParentTwo__r.Start_Date__c FROM Junction__c ];

Map<Id, Id> mapName = new Map<Id, Id>();



for (junction__c jun : junction) {
    mapName.put(jun.ParentOne__c, jun.ParentTwo__c);
}

System.debug(mapName);