public class EmployeeTriggerHandler {
    
    public static void beforeInsert(List<Employee__c> newList) {
        updateActiveField(newList);
    }
    
    public static void afterInsert(List<Employee__c> newList) {
    }
     
    public static void beforeUpdate(List<Employee__c> newList, Map<Id, Employee__c> oldMap) {
    }
     
    public static void afterUpdate(List<Employee__c> newList, Map<Id, Employee__c> oldMap) {
    }
     
    public static void beforeDelete(List<Employee__c> oldList) {
    }
     
    public static void afterDelete(List<Employee__c> oldList) {
        updateLeftEmployeeCountAccountField(oldList);
    }

    public static void afterUndelete(List<Employee__c> newList) {
        updateActiveField(newList);
        
    }

    private static void updateLeftEmployeeCountAccountField(List<Employee__c> employees) {
        List<Account> accounts = AccountFinder.getEmployeesRelatedAccounts(employees);
        if (!accounts.isEmpty()) {
            update accounts;
        }
    }

    private static void updateActiveField(List<Employee__c> employees){
        List<Account> accounts = new List<Account>();
        Set<Id> employeeIds = new Set<Id>();
        for(Employee__c employee : employees){
            employee.Active__c = true;
            employeeIds.add(employee.AccountId__c);
        }
        List<Account> newAccount = new List<Account>();
        newAccount = [SELECT Id,(SELECT Id, Name FROM Employees__r) FROM Account WHERE Id =: employeeIds];
        for(Account account : newAccount){
            account.Active__c = 'Yes';
            account.Left_Employee_Count__c = account.Employees__r.size();
            account.Present_Employee_Count__c = account.Employees__r.size();
            accounts.add(account);
        }
        if(!accounts.isEmpty()){
            update accounts;
        }
    }
}