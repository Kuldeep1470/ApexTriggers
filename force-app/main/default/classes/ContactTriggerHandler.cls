public with sharing class ContactTriggerHandler {
	public static void beforeInsert(List<Contact> newList) {
		priventContactOnDuplicateEmail(newList);
    }
    
    public static void afterInsert(List<Contact> newList) {
        sendEmail(newList);
    }
    
    public static void beforeUpdate(List<Contact> newList, Map<Id, Contact> oldMap) {
        
    }
    
    public static void afterUpdate(List<Contact> newList, Map<Id, Contact> oldMap) {

    }
    
    public static void beforeDelete(List<Contact> oldList) {
        
    }
    
    public static void afterDelete(List<Contact> oldList) {
        
    }

    private static void priventContactOnDuplicateEmail(List<Contact> contacts) {
        Set<String> contactEmails = new Set<String>();
        List<Contact> allContacts = [SELECT Id, Email FROM Contact];

        for (Contact contact : allContacts) {
            if (contact.Email != NULL) {
                contactEmails.add(contact.Email);
            }
        }

        for (Contact contact : contacts) {
            if (contactEmails.contains(contact.Email)) {
                contact.addError('This email is exist in another contact you can not create contact with this email');
            }
        }
    }

    private static void sendEmail(List<Contact> contacts) {
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
    
        for(Contact contact: contacts) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String name = ((contact.FirstName != NULL) ? contact.FirstName : '') + contact.LastName;
                mail.setTargetObjectId(contact.Id);
                mail.setReplyTo(contact.Email);
                mail.setSenderDisplayName(name);
                mail.setSubject('new Contact Created to Account');
                String body = 'Dear';
                body += name+' your new contact created.';
                mail.setHtmlBody(body);
                mails.add(mail);
        }
        if(!mails.isEmpty()) {
            Messaging.sendEmail(mails);
        }
    }
}