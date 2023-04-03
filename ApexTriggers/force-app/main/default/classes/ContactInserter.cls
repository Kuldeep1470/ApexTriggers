public class ContactInserter {
    public static List<contact> insertContact(List<Account> accounts){
        List<Contact> contacts = new List<Contact>();
        Contact contact;
        for(Account account : accounts){
            contact = new Contact();
            contact.AccountId = account.Id;
            contact.FirstName = account.Name.substringBefore(' ');
            if(account.Name.contains(' ')){
                contact.LastName = account.Name.substringAfter(' ');
            }
            else{
                contact.LastName = account.Name;
            }
            contact.Phone = account.Phone;
            contact.Description = account.Description;
            contact.Jigsaw = account.Jigsaw;
            contacts.add(contact);
        }
        return contacts;
    }
}