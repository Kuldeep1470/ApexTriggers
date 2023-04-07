public with sharing class AccountTriggerHandler {
    
    public static void beforeInsert(List<Account> newList) {
       setRatingForMedia(newList);
       copyBillingToShipping(newList);
    }
    
    public static void afterInsert(List<Account> newList) {
        insertDefaultAccountContact(newList);
        insertOpportunity(newList);
    }
    
    public static void beforeUpdate(List<Account> newList, Map<Id, Account> oldMap) {
        updateBillingToShipping(newList, oldMap);
        updateRatingForMedia(newList, oldMap);
        showUpdateMessage(newList, oldMap);
        /* desableEditAccordingCreationDate(newList); */
    }

    public static void afterUpdate(List<Account> newList, Map<Id, Account> oldMap) {
        updateHomePhoneOnRelatedContacts(newList, oldMap);
        updateRelatedAccountOpportunityStage(newList, oldMap);
    }
    
    public static void beforeDelete(List<Account> oldList) {
        /* disableDeleteOnActiveYes(oldList); */
        preventDeleteAccountHaveOpportunity(oldList);
        preventDeleteAccountHaveCase(oldList);
        /* onlySystemAdminCanDelete(oldList); */
    }
    
    public static void afterDelete(List<Account> oldList) {
        
    }

   /* private static void onlySystemAdminCanDelete(List<Account> accounts) {
         Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        for (Account account : accounts) {
             if (adminId != UserInfo.getProfileId()) {
                account.addError('Only System admin can delete the account');
            }
        }
    }
    */
    private static void preventDeleteAccountHaveOpportunity(List<Account> accounts) {
        List<Opportunity> opportunities = [SELECT Id , AccountId FROM Opportunity];
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opportunity : opportunities) {
            accountIds.add(opportunity.AccountId);
        }
        for (Account account : accounts) {
            if (accountIds.contains(account.Id)) {
                account.addError('This account have opportunity you can not delete this account');
            }
        }
    }

    private static void preventDeleteAccountHaveCase(List<Account> accounts) {
        List<Case> cases = [SELECT Id , AccountId FROM Case];
        Set<Id> accountIds = new Set<Id>();
        for (Case caseInstance : cases) {
            accountIds.add(caseInstance.AccountId);
        }
        for (Account account : accounts) {
            if (accountIds.contains(account.Id)) {
                account.addError('This account have case you can not delete this account');
            }
        }
    }

    private static void setRatingForMedia(List<Account> accounts){
        for(Account account : accounts){
            if(account.Industry != NULL && account.Industry == 'Media'){
                account.Rating = 'Hot';
            }
        }
    }

    private static void updateRatingForMedia(List<Account> accounts, Map<Id, Account> accountMap){
        for(Account account : accounts){
            if(accountMap.containskey(account.Id) 
               && account.Industry != accountMap.get(account.Id).Industry
               && account.Industry != NULL && account.Industry == 'Media'){
                account.Rating = 'Hot';
            }
        }
    }
    
    private static void copyBillingToShipping(List<Account> accounts){
        for (Account account : accounts) {
             if(account.CopyBillingToShipping__c){

                if(account.BillingStreet != NULL){
                    account.ShippingStreet = account.BillingStreet;
                }

                if(account.BillingCity != NULL){
                    account.ShippingCity = account.BillingCity;
                }

                if(account.BillingCountry != NULL){
                    account.ShippingCountry = account.BillingCountry;
                }

                if(account.BillingGeocodeAccuracy != NULL){
                    account.ShippingGeocodeAccuracy = account.BillingGeocodeAccuracy;
                }

                if(account.BillingLatitude != NULL){
                    account.ShippingLongitude = account.BillingLatitude;
                }

                if(account.BillingLongitude != NULL){
                    account.ShippingLongitude = account.BillingLongitude;
                }

                if(account.BillingPostalCode != NULL){
                    account.ShippingPostalCode = account.BillingPostalCode;
                }

                if(account.BillingState != NULL){
                    account.ShippingState = account.BillingState;
                }

             }
        }
    }

    private static void updateBillingToShipping(List<Account> accounts, Map<Id, Account> accountMap){
        for (Account account : accounts) {
             if(account.CopyBillingToShipping__c){

                if(account.BillingStreet != NULL && account.BillingStreet != accountMap.get(account.Id).BillingStreet){
                    account.ShippingStreet = account.BillingStreet;
                }

                if(account.BillingCity != NULL && account.BillingCity != accountMap.get(account.Id).BillingCity){
                    account.ShippingCity = account.BillingCity;
                }

                if(account.BillingCountry != NULL && account.BillingCountry != accountMap.get(account.Id).BillingCountry){
                    account.ShippingCountry = account.BillingCountry;
                }
                
                if(account.BillingGeocodeAccuracy != NULL && account.BillingGeocodeAccuracy != accountMap.get(account.Id).BillingGeocodeAccuracy){
                    account.ShippingGeocodeAccuracy = account.BillingGeocodeAccuracy;
                }

                if(account.BillingLatitude != NULL && account.BillingLatitude != accountMap.get(account.Id).BillingLatitude){
                    account.ShippingLatitude = account.BillingLatitude;
                }

                if(account.BillingLongitude != NULL && account.BillingLongitude != accountMap.get(account.Id).BillingLongitude){
                    account.ShippingLongitude = account.BillingLongitude;
                }

                if(account.BillingPostalCode != NULL && account.BillingPostalCode != accountMap.get(account.Id).BillingPostalCode){
                    account.ShippingPostalCode = account.BillingPostalCode;
                }

                if(account.BillingState != NULL && account.BillingState != accountMap.get(account.Id).BillingState){
                    account.ShippingState = account.BillingState;
                }
                
             }
        }
    }

    private static void showUpdateMessage(List<Account> accounts, Map<Id, Account> accountMap){
        for (Account account : accounts) {
            if(accountMap.containskey(account.Id) && account.Phone != accountMap.get(account.Id).Phone){
                account.Description = 'Phone is Updated!';
            }
        }
    }

    private static void disableDeleteOnActiveYes(List<Account> accounts) {
        for (Account account : accounts) {
            if (account.Active__c == 'yes') {
                account.addError('Can not delete account field with value yes');
            }
        }
    }

    private static void desableEditAccordingCreationDate(List<Account> accounts) {
        for (Account account : accounts) {
            if (account.CreatedDate > System.today().addDays(-7)) {
                account.addError('You can not edit account created back 7 days');
            }
        }
    }
    
    private static void insertDefaultAccountContact(List<Account> account){
        ContactFinder.accountRelatedContact(account);
    }

    private static void insertOpportunity(List<Account> accounts){
        OpportunityFinder.accountRelatedOpportunity(accounts);
    }

    private static void updateHomePhoneOnRelatedContacts(List<Account> accounts, Map<Id, Account> accountMap){
        ContactFinder.accountRelatedContact(accounts, accountMap);
    }

    private static void updateRelatedAccountOpportunityStage(List<Account> accounts, Map<Id, Account> accountMap) {
        OpportunityFinder.getAccountRelatedOpportunity(accounts, accountMap);
    }
}