public with sharing class UserBirthdayEmail {

    private static List<User> userBirtthdayidToday(List<User> users){
        List<User> usersBirthdays = new List<User>();

        for(User user : users){
            Datetime birthDay = (Datetime)user.Date_Of_Birth__c;
            if( birthDay != NULL 
                && birthDay.day() == System.today().day() 
                && birthDay.month() == System.today().month() ){
                usersBirthdays.add(user);
            }
        }
        return usersBirthdays;
    }

    public static void sendEmailToUsers(){
        List<User> users = [SELECT Name, Email, Date_Of_Birth__c FROM User WHERE Email != NULL];
        Id birthTemplateId = [SELECT Id FROM EmailTemplate WHERE  Name = 'UserBirthday']?.Id;
       
        List<User> usersBirthdays = userBirtthdayidToday(users);

        if(usersBirthdays.isEmpty()){ return; }

        List<Messaging.SingleEmailMessage> BirthdayMails = new List<Messaging.SingleEmailMessage>();

        String[] sendTo = new List<String>();

        for (User user : users) {
            if(Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}', user.Email)){
                sendTo.add(user.Email);
            }
        }

        for(User user : usersBirthdays){
                Messaging.SingleEmailMessage BirthdayMail = new Messaging.SingleEmailMessage();
                BirthdayMail.setTemplateId(birthTemplateId);
                BirthdayMail.setTargetObjectId(user.Id);
                BirthdayMail.setCcAddresses(sendTo);
                BirthdayMail.setSaveAsActivity(false);
                BirthdayMails.add(BirthdayMail);
        }

        if(!BirthdayMails.isEmpty()){
            Messaging.sendEmail(BirthdayMails);
        }
    }

}