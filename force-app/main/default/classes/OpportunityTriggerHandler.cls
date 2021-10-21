public class OpportunityTriggerHandler {
    
    public static void afterInsert(List<Opportunity> newList){
        Set<Id> accountId = new Set<Id>();
        for(Opportunity objOpp : newList){
            if(objOpp.StageName != 'Closed Won' || objOpp.StageName != 'Closed Lost'){
                accountId.add(objOpp.AccountId);
            }   
        }
        if(accountId.size() > 0){
            updateAccount(accountId);
        }
    }
    public static void afterUpdate(Map<Id,Opportunity> newMap, Map<Id,Opportunity> oldMap){
        Set<Id> accountId = new Set<Id>();
        for(Opportunity objOpp : newMap.values()){
            if(objOpp.StageName != oldMap.get(objOpp.Id).StageName){
                accountId.add(objOpp.AccountId);
            }   
        }
        if(accountId.size() > 0){
            updateAccount(accountId);
        }
    }
    
    public static void updateAccount(Set<Id> accountId){
        List<Account> objUpdateAccount = new List<Account>();
        for(AggregateResult aggResult : [SELECT AccountId , count(Id) oppCount From Opportunity 
                                         WHERE (AccountId IN  : accountId AND StageName != 'Closed Won' AND  StageName != 'Closed Lost') 
                                         Group By AccountId]){
                                             objUpdateAccount.add(new Account(Id = (Id)aggResult.get('AccountId'),
                                                                              Open_Opportunity__c = (Decimal)aggResult.get('oppCount')));
                                             accountId.remove((Id)aggResult.get('AccountId'));
                                         }
        for(Id accId : accountId){
            objUpdateAccount.add(new Account(Id = accId,Open_Opportunity__c = 0));
        }
        If(objUpdateAccount.size() > 0){
            Update objUpdateAccount;
        }
        
    }
}