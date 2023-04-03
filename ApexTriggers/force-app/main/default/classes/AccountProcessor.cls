public class AccountProcessor {
    @future
      public static void countContacts(Set<id> accountIds){
      List<Account> accounts = [select id,Number_of_Contacts__c , (select id from contacts ) from account where id in :accountIds ];
      for( Account account : accounts ){
          List<Contact> contacts = account.contacts;
          account.Number_of_Contacts__c = contacts.size();
      }
      update accounts;
  }
}