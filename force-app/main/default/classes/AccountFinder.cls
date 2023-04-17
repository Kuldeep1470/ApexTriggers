public with sharing class AccountFinder {

    public static List<Account> opportunityRelatedAccounts(List<Opportunity> opportunities){
        List<Account> accounts = new List<Account>();

        for(Opportunity opportunity : opportunities){
            if(opportunity.AccountId != NULL){
                Account account = new Account();
                account.Id = opportunity.AccountId;
                account.recentOpportunityAmount__c = opportunity.Amount;
                accounts.add(account);
            }
        }

        return accounts;
    }

    public static List<Account> UpdateOpportunityRelatedAccounts(Set<Id> AccountIds) {
        List<Account> accounts = new List<Account>();
        AggregateResult[] groupedResults = [SELECT AccountId, Sum(Amount)annulRevenue FROM Opportunity  WHERE AccountId IN: AccountIds GROUP BY AccountId];

        for (AggregateResult variable : groupedResults) {
            String accountId = String.valueOf(variable.get('AccountId'));
            Integer annualRevenue = Integer.valueOf(variable.get('annulRevenue'));
            accounts.add(new Account(Id = accountId, AnnualRevenue = annualRevenue));
            System.debug(variable.get('AccountId')+ '->' + variable.get('annulRevenue'));
        }

        return accounts;
    }

    public static List<Account> caseRelatedAccounts(List<Case> cases){
        List<Account> accounts = new List<Account>();
        for(Case newCase : cases){
            if(newCase.AccountId != NULL){
                Account account = new Account();
                account.Id = newCase.AccountId;
                account.LatestCaseNumber__c = newCase.CaseNumber;
                accounts.add(account);
            }
        }
        return accounts;
    }

    public static List<Account> caseRelatedAccountsWithRecordTypes(Set<Id> accountIds){
        List<Account> accounts = new List<Account>();
        Id customerCaseId = [SELECT Id, Name FROM RecordType WHERE Name = 'Customer Case'].Id;
        Id partnerCaseId =  [SELECT Id, Name FROM RecordType WHERE Name = 'Partner Case'].Id;
        Map<Id, Account> accountWithcustomerCase = new Map<Id, Account>([Select Id, Customer_Case_Total_Numbers__c, Partner_Case_Total_Numbers__c, (SELECT Id, RecordTypeId FROM Cases WHERE RecordTypeId =:customerCaseId) FROM Account WHERE Id IN:accountIds]);
        Map<Id, Account> accountWithPartnerCase = new Map<Id, Account>([Select Id, Customer_Case_Total_Numbers__c, Partner_Case_Total_Numbers__c, (SELECT Id, RecordTypeId FROM Cases WHERE RecordTypeId =:partnerCaseId) FROM Account WHERE Id IN:accountIds]);

        for (Id accountId : accountIds) {
            Account account = new Account();
            account.Id = accountId;
            if (accountWithcustomerCase.containsKey(accountId)) {
                account.Customer_Case_Total_Numbers__c = accountWithcustomerCase.get(accountId).Cases.size();
            }
            if (accountWithPartnerCase.containsKey(accountId)) {
                account.Partner_Case_Total_Numbers__c = accountWithPartnerCase.get(accountId).Cases.size();
            }
            accounts.add(account);
        }

        return accounts;
    }

    public static List<Account> getEmployeesRelatedAccounts(List<Employee__c> employees) {
        Set<Id> accountIds = new Set<Id>();
        for (Employee__c employee : employees) {
            accountIds.add(employee.AccountId__c);
        }
        
        List<Account> accounts =[SELECT Id, Name, Left_Employee_Count__c, (SELECT Id, AccountId__c FROM Employees__r) FROM Account];
        for (Account account : accounts) {
            account.Left_Employee_Count__c = account.Employees__r.size();
            account.Present_Employee_Count__c = account.Employees__r.size();
        }
        return accounts;
    }

}