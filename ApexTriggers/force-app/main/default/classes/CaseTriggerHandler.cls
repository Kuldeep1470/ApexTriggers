public class CaseTriggerHandler {
	public static void beforeInsert(List<Case> newList) {
		
    }
    
    public static void afterInsert(List<Case> newList) {
		putLatestAccountCaseNumber(newList);
		showNumbersOfCaseRecordTypes(newList);
    }
    
    public static void beforeUpdate(List<Case> newList, Map<Id, Case> oldMap) {
        
    }
    
    public static void afterUpdate(List<Case> newList, Map<Id, Case> oldMap) {

    }
    
    public static void beforeDelete(List<Case> oldList) {
        
    }
    
    public static void afterDelete(List<Case> oldList) {
        
    }
    
    private static void putLatestAccountCaseNumber(List<Case> cases){
        AccountFinder.caseRelatedAccounts(cases);
    }

    private static void showNumbersOfCaseRecordTypes(List<Case> cases) {
        Set<Id> caseRelatedAccounts = new Set<Id>();

        for (Case accountCase : cases) {
           caseRelatedAccounts.add(accountCase.AccountId);
        }

        AccountFinder.caseRelatedAccountsWithRecordTypes(caseRelatedAccounts);
    }
}