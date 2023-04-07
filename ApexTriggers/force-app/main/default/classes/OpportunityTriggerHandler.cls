public with sharing class OpportunityTriggerHandler {
        
    public static void beforeInsert(List<Opportunity> newList) {
        fillOpportunityDescription(newList);
        showUpdateStage(newList);
    }
    
    public static void afterInsert(List<Opportunity> newList) {
        recentAccountOpportunityAmount(newList);
        UpdateRelatedAccounts(newList);
    }
    
    public static void beforeUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        showUpdateStage(newList, oldMap);
        provideCloseLostResion(newList, oldMap);
    }
    
    public static void afterUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        UpdateRelatedAccounts(newList, oldMap);
        assignTaskToCurruntUser(newList, oldMap);
    }
    
    public static void beforeDelete(List<Opportunity> oldList) {
        onlySystemAdminCanDelete(oldList);
    }
    
    public static void afterDelete(List<Opportunity> oldList) {
        UpdateRelatedAccounts(oldList);
    }

    private static void onlySystemAdminCanDelete(List<Opportunity> opportunities) {
        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        for (Opportunity opportunity : opportunities) {
            if (adminId != UserInfo.getProfileId()) {
                opportunity.addError('Only System admin can delete the opportunity');
            }
        }
    }

    private static void showUpdateStage(List<Opportunity> opportunities){
        for (Opportunity opportunity : opportunities) {
            if(opportunity.StageName == 'Closed Won'){
                opportunity.Description = 'Opp is Closed Won';
            }
            else if(opportunity.StageName == 'Closed Lost'){
                opportunity.Description = 'Opp is Closed Lost';
            }
            if(opportunity.StageName == 'Closed Won'){
                opportunity.Description = 'Opp is Open';
            }
        }
    }

    private static void provideCloseLostResion(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap) {
        for (Opportunity opportunity : opportunities) {
            if (opportunity.StageName != opportunityMap.get(opportunity.Id).StageName 
                && opportunity.StageName == 'Closed Lost' && opportunity.Closed_Lost_Reason__c == NULL) {
                opportunity.addError('Please populate Closed Lost Reason');
            }
        }
    }

    private static void showUpdateStage(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap){
        for (Opportunity opportunity : opportunities) {
            if (opportunityMap.containskey(opportunity.Id) && opportunity.StageName != opportunityMap.get(opportunity.Id).StageName) {
                if(opportunity.StageName == 'Closed Won'){
                    opportunity.Description = 'Opp is Closed Won';
                }
                else if(opportunity.StageName == 'Closed Lost'){
                    opportunity.Description = 'Opp is Closed Lost';
                }
                if(opportunity.StageName == 'Closed Won'){
                    opportunity.Description = 'Opp is Open';
                }
            }
        }
    }

    /*  private static void showUpdateStage(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap){
        Integer i = 0;
        showUpdateStageReccursion( opportunities, opportunityMap, i);
    }

    private static void showUpdateStageReccursion(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap, Integer n) {
        
        Opportunity opportunity = opportunities.get(n);
        if (opportunityMap.containskey(opportunity.Id) && opportunity.StageName != opportunityMap.get(opportunity.Id).StageName) {
            if(opportunity.StageName == 'Closed Won'){
                opportunity.Description = 'Opp is Closed Won';
            }
            else if(opportunity.StageName == 'Closed Lost'){
                opportunity.Description = 'Opp is Closed Lost';
            }
            if(opportunity.StageName == 'Closed Won'){
                opportunity.Description = 'Opp is Open';
            }
        }
        if (opportunities.size() > n) {
            showUpdateStageReccursion(opportunities, opportunityMap, n++);
        }
    }*/
    
    private static void fillOpportunityDescription(List<Opportunity> opportunities){
        for(Opportunity opportunity : opportunities){
            if(opportunity.Amount != null && opportunity.Amount > 100000){
                opportunity.Description =  'Hot Opportunity';
            }
        }
    }

    private static void UpdateRelatedAccounts(List<Opportunity> opportunities) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opportunity : opportunities) {
            accountIds.add(opportunity.AccountId);
        }
        AccountFinder.UpdateOpportunityRelatedAccounts(accountIds);
    }

    private static void UpdateRelatedAccounts(List<Opportunity> opportunities, Map<Id, Opportunity> opportunityMap) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opportunity : opportunities) {
            if (opportunity.Amount != opportunityMap.get(opportunity.Id).Amount) {
                accountIds.add(opportunity.AccountId);
            }
        }
        AccountFinder.UpdateOpportunityRelatedAccounts(accountIds);
    }

    
    private static void recentAccountOpportunityAmount(List<Opportunity> opportunities){
        AccountFinder.opportunityRelatedAccounts(opportunities);
    }

    private static void assignTaskToCurruntUser(List<Opportunity> opportunity, Map<Id, Opportunity> opportunityMap){
        TaskFinder.getOpportunityRelatedTasks(opportunity, opportunityMap);
    }
}