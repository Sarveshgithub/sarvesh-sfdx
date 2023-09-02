public class ContactTriggerHandler {
    public static void handleBeforeInsert(List<Contact> newList) { 
        // Add your before insert logic here
        Set<Id> accIds = new Set<Id>();
            for(Contact objCon : newList){
                accIds.add(objCon.AccountId);  
            }
        Map<Id,Account> mapOfAccount = new Map<Id,Account>([SELECT id,Name from Account where Id = : accIds]);
        for(Contact objCon : newList){
            String accountName = mapOfAccount.get(objCon.AccountId).Name;
            objCon.Firstname = objCon.Firstname +' | ' + accountName;
        }
    }

    public static void handleBeforeUpdate(List<Contact> newList, List<Contact> oldList) {
        // Add your before update logic here
    }

    public static void handleBeforeDelete(List<Contact> oldList) {
        // Add your before delete logic here
    } 
    public static void handleAfterInsert(List<Contact> newList) {
        // Add your after insert logic here
    }

    public static void handleAfterUpdate(List<Contact> newList, List<Contact> oldList) {
        // Add your after update logic here
    }

    public static void handleAfterDelete(List<Contact> oldList) {
        // Add your after delete logic here
    }

    public static void handleAfterUndelete(List<Contact> newList) {
        // Add your after undelete logic here
    }

}