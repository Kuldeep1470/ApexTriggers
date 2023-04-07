public class ContactFinder {

    public static void accountRelatedContact(List<Account> accounts){
        List<Contact> contacts = new List<Contact>();
        for(Account account : accounts) {
            if(account.Contact__c) {
                Contact contact = new Contact();

                if(account.Name.contains(' ')){
                    contact.LastName = account.Name.substringAfter(' ');
                }
                else{
                    contact.LastName = account.Name;
                }

                contact.AccountId = account.Id;
                contact.FirstName = account.Name.substringBefore(' ');
                contact.Phone = account.Phone;
                contact.Description = account.Description;
                contact.Jigsaw = account.Jigsaw;
                contacts.add(contact);
            }
        }
        if (!contacts.isEmpty()) {
            insert contacts;
        }
    }
/*
    public static List<contact> accountRelatedContact(List<Account> accounts, Map<Id, Account> accountMap){
        Map<Id, Account> newAccountMap = new Map<Id, Account>(accounts);
        List<Contact> contacts = [SELECT Id, HomePhone, AccountId, MailingCity, MailingCountry,
                                  MailingGeocodeAccuracy, MailingLatitude, MailingPostalCode, MailingState, MailingStreet
                                  FROM Contact WHERE AccountId IN:newAccountMap.keySet()];

        for (Contact contact : contacts) {
            Account account = accountMap.get(contact.AccountId);
            Account newAccount = newAccountMap.get(contact.AccountId);

            if(newAccount.Phone != account.Phone){
                contact.HomePhone = newAccount.Phone;
            }

            if(newAccount.BillingCity != NULL && newAccount.BillingCity != account.BillingCity) { 
                contact.MailingCity = newAccount.BillingCity;
            }

            if(newAccount.BillingCountry != NULL && newAccount.BillingCountry != account.BillingCountry) { 
                contact.MailingCountry = newAccount.BillingCountry;
            }

            if(newAccount.BillingGeocodeAccuracy != NULL && newAccount.BillingGeocodeAccuracy != account.BillingGeocodeAccuracy) { 
                contact.MailingGeocodeAccuracy = newAccount.BillingGeocodeAccuracy;
            }

            if(newAccount.BillingLatitude != NULL && newAccount.BillingAddress != account.BillingAddress) { 
                contact.MailingLatitude = newAccount.BillingLatitude;
            }

            if(newAccount.BillingPostalCode != NULL && newAccount.BillingPostalCode != account.BillingPostalCode) { 
                contact.MailingPostalCode = newAccount.BillingPostalCode;
            }

            if(newAccount.BillingState != NULL && newAccount.BillingState != account.BillingState) { 
                contact.MailingState = newAccount.BillingState;
            }

            if(newAccount.BillingStreet != NULL && newAccount.BillingStreet != account.BillingStreet) { 
                contact.MailingStreet = newAccount.BillingStreet;
            }
        }
        return contacts;
    }
    */

    public static void accountRelatedContact(List<Account> accounts, Map<Id, Account> accountMap){

        List<Account> accountsWithContacts = [ SELECT Id, Phone, BillingStreet, BillingState, BillingPostalCode, BillingAddress, BillingGeocodeAccuracy, BillingCountry, BillingCity, BillingLatitude,
                                             ( SELECT Id, HomePhone, AccountId, MailingCity, MailingCountry, MailingGeocodeAccuracy, MailingLatitude, MailingPostalCode, MailingState, MailingStreet 
                                               FROM Contacts ) FROM Account WHERE Id IN: accountMap ];
        List<Contact> contacts = new List<Contact>();
        for (Account account : accountsWithContacts) {
            
                for (Contact contact : account.contacts) {

                    Account oldAccount = accountMap.get(account.Id);
                    if(account.Phone != oldAccount.Phone){
                        contact.HomePhone = account.Phone;
                    }

                    if(account.BillingCity != NULL && account.BillingCity != oldAccount.BillingCity) { 
                        contact.MailingCity = account.BillingCity;
                    }

                    if(account.BillingCountry != NULL && account.BillingCountry != oldAccount.BillingCountry) { 
                        contact.MailingCountry = account.BillingCountry;
                    }

                    if(account.BillingGeocodeAccuracy != NULL && account.BillingGeocodeAccuracy != oldAccount.BillingGeocodeAccuracy) { 
                        contact.MailingGeocodeAccuracy = account.BillingGeocodeAccuracy;
                    }

                    if(account.BillingLatitude != NULL && account.BillingAddress != oldAccount.BillingAddress) { 
                        contact.MailingLatitude = account.BillingLatitude;
                    }

                    if(account.BillingPostalCode != NULL && account.BillingPostalCode != oldAccount.BillingPostalCode) { 
                        contact.MailingPostalCode = account.BillingPostalCode;
                    }
                    
                    if(account.BillingState != NULL && account.BillingState != oldAccount.BillingState) { 
                        contact.MailingState = account.BillingState;
                    }
                    
                    if(account.BillingStreet != NULL && account.BillingStreet != oldAccount.BillingStreet) { 
                        contact.MailingStreet = account.BillingStreet;
                    }
                    contacts.add(contact);
                    
                }
                
            }
    
        if (!contacts.isEmpty()) {
            update contacts;
        }
    }


}