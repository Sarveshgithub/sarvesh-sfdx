public class ContactTriggerHandler {
    public static void handleBeforeInsert(List<Contact> newList, Map<Id, Contact> newMap, Map<Id, Contact> oldMap) {
        // Add your before insert logic here
        updateName(newList);
    }

    public static void handleBeforeUpdate(List<Contact> newList, Map<Id, Contact> newMap, Map<Id, Contact> oldMap) {
        // Add your before update logic here
        // Add your before update logic here
        List<Contact> lstCon = new List<Contact>();
        for (Contact objCon : newMap.values()) {
            if (objCon.LastName != oldMap.get(objCon.Id).LastName) {
                lstCon.add(objCon);
            }
        }
        updateName(lstCon);
    }

    public static void handleBeforeDelete(Map<Id, Contact> oldMap, Map<Id, Contact> newMap) {
        // Add your before delete logic here
        deleteRelatedCase(oldMap.keySet());
    }

    public static void handleAfterInsert(List<Contact> newList, Map<Id, Contact> newMap, Map<Id, Contact> oldMap) {
        // Add your after insert logic here
    }

    public static void handleAfterUpdate(List<Contact> newList, Map<Id, Contact> newMap, Map<Id, Contact> oldMap) {
        // Add your after update logic here
        List<Contact> lstCon = new List<Contact>();
        for (Contact objCon : newMap.values()) {
            if (objCon.Department != oldMap.get(objCon.Id).Department && objCon.Department == 'tech') {
                lstCon.add(objCon);
            }
        }
        createCase(lstCon);
    }

    public static void handleAfterDelete(Map<Id, Contact> oldMap, Map<Id, Contact> newMap) {
        // Add your after delete logic here
    }

    public static void handleAfterUndelete(List<Contact> newList, Map<Id, Contact> newMap, Map<Id, Contact> oldMap) {
        // Add your after undelete logic here
    }

    private static void updateName(List<Contact> newList) {
        Set<Id> accIds = new Set<Id>();
        for (Contact objCon : newList) {
            accIds.add(objCon.AccountId);
        }
        Map<Id, Account> mapOfAccount = new Map<Id, Account>([SELECT id, Name FROM Account WHERE Id = :accIds]);
        for (Contact objCon : newList) {
            String accountName = mapOfAccount.get(objCon.AccountId).Name;
            objCon.LastName = objCon.LastName + ' | ' + accountName;
        }
    }

    private static void createCase(List<Contact> lstCon) {
        List<Case> casesToInsert = new List<Case>();
        for (Contact objCon : lstCon) {
            Case newCase = new Case(Subject = 'Tech Industry', Description = 'Industry field updated on Contact', ContactId = objCon.Id);
            casesToInsert.add(newCase);
        }
        // Insert the new Case records
        if (!casesToInsert.isEmpty()) {
            insert casesToInsert;
        }
    }

    private static void deleteRelatedCase(Set<id> conId) {
        delete [SELECT id FROM Case WHERE contactId IN :conId];
    }
}
