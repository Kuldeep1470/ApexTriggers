global with sharing class UserBirthdayScheduler implements Schedulable {

    global void execute(SchedulableContext SC) {
        UserBirthdayEmail.sendEmailToUsers();
    }

    public static void scheduleJOb() {
        Datetime currentTime = Datetime.now().addMinutes(5);
        String CronExp = ''+ currentTime.second() +' '+currentTime.minute() +' '+currentTime.hour() +' '+currentTime.day()+' '+currentTime.month() + ' ? '+currentTime.year(); 
        System.schedule('Birthday emial Job ' + currentTime , CronExp, new UserBirthdayScheduler());
    }
}