@isTest
private class DailyLeadProcessorTest {
    public static String CRON_EXP = '0 0 0 DATE MONTH ? YEAR';
    static TestMethod void  tetslead(){
        List<Lead> l= new List<Lead>();
        lead l1= new Lead();
        l1.LastName='surya';
        l1.Company='Company';
        l1.Status='Closed-Converted';
       
        l.add(l1);
        insert l;
   
    Test.startTest();
        String jobId = System.schedule('ScheduledApexTest',CRON_EXP,new DailyLeadProcessor()); 
    Test.stopTest();
    }
}