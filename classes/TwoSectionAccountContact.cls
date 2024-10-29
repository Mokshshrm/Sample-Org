public  class TwoSectionAccountContact {
    
    public class Result{
        
        @AuraEnabled
        public String accounts{get;set;}
        
        @AuraEnabled
        public List<Contact> contacts{get;set;}
        
    }
    
    @AuraEnabled
    public static Result getAccounts(String str){
        
        Result res = new Result();
        
        Account tmp = [SELECT Id,Name FROM Account WHERE Name LIKE :str LIMIT 1];
        
        // Set<Id> accountsSet = new Map<Id,account>(res.accounts).keySet();
        
        res.accounts = (tmp.Id).toString();
        
        
        
        res.contacts = [SELECT LastName,AccountId FROM Contact WHERE AccountId =:tmp.Id];
        
        return res;
    }
    
    @AuraEnabled
    public static void updateParent(String newParent, String ContactId){
        
        Id recorID = Id.valueOf(ContactId);
        Id newAc = Id.valueOf(newParent);
        
        Contact it = [SELECT ID FROM Contact WHERE Id=:recorID];
        it.AccountId = newAc;
        update it;
        return;
    }
    
}