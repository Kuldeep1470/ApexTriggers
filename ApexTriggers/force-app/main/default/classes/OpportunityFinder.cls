public with sharing class OpportunityFinder {
    public static List<Opportunity> accountRelatedOpportunity(List<Account> accounts) {
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Account account : accounts) {
            if(account.Opportunity__c && account.Active__c =='yes'){
                Opportunity opportunity = new Opportunity();
                opportunity.AccountId = account.Id;
                opportunity.CloseDate = System.today();
                opportunity.Name = account.Name;
                opportunity.Description = account.Description;
                opportunity.StageName = 'prospect';
                opportunities.add(opportunity);
            }
        }
        return opportunities;
    }

    public static List<Opportunity> getAccountRelatedOpportunity(List<Account> accounts, Map<Id,Account> accountMap) {
        List<Opportunity> opportunities = [SELECT Id, StageName, Annual_Revenue__c, Account.AnnualRevenue, AccountId, Account.Active__c FROM Opportunity WHERE AccountId IN: accountMap.keySet()];
        
        for (Opportunity opportunity : opportunities) {
            if (opportunity.Account.Active__c != accountMap.get(opportunity.AccountId).Active__c 
                && opportunity.Account.Active__c == 'no' 
                && accountMap.get(opportunity.AccountId).Active__c == 'yes' 
                && opportunity.StageName != 'Closed Won') {
                opportunity.StageName = 'Close Lost';
            }
            if (opportunity.Account.AnnualRevenue != NULL && opportunity.Account.AnnualRevenue !=  accountMap.get(opportunity.AccountId).AnnualRevenue) {
                opportunity.Annual_Revenue__c = opportunity.Account.AnnualRevenue;
            }
        }
        
        return opportunities;
    }
}