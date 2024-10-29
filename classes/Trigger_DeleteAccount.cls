public without sharing class Trigger_DeleteAccount {
    
    static Boolean run = true;
    
    Boolean isBefore, isAfter, isInsert, isUpdate, isDelete,isUndelete;
    List<Contact> newRec,oldRec;
    Map<Id,Contact> newMap, oldMap;
    
    
    public Trigger_DeleteAccount(Boolean isBefore,Boolean isAfter,Boolean isInsert,Boolean isUpdate,Boolean isDelete,Boolean isUndelete,List<Contact> newRec,Map<Id,Contact> newMap,List<Contact> oldRec,Map<Id,Contact> oldMap){
        this.isBefore=isBefore;
        this.isAfter=isAfter;
        this.isInsert=isInsert;
        this.isUpdate=isUpdate;
        this.isDelete=isDelete;
        this.isUndelete=isUndelete;
        this.newRec=newRec;
        this.oldRec = oldRec;
        this.newMap =newMap;
        this.oldMap=oldMap;
    }
    
    public Boolean checkCanRun(){
        
        if(run){
            run = false;
            return true;
        }else{
            return run;
        }
    }
    
    public void afterInsert(){
        CalCulateRollUpSummary();
    }
    
    public void beforeInsert(){
        DivideAllContact();
    }
    
    public void beforeUpdate(){
        DivideAllContact();
    }
    
    public void afterUpdate(){
        CalCulateRollUpSummary();
    }
    
    public void beforeDelete(){
        
    }
    
    public void afterDelete(){
        CalCulateRollUpSummary();
        delContactsAccount();
    }
    
    
    
    //  1 ------------------- Roll Up Summary  -------------------
    
    
    private void CalCulateRollUpSummary(){
        
        List<Account> AccountUpdate = new List<Account>();
        
        try{
            
            // 1. When Inserted;
            // Amount__c TotalAmount__c
            
            Set<Id> AccountIds = new Set<Id>();
            
            if(newRec != null){
                for(Contact it : newRec){
                    if(it.AccountId != null)
                        AccountIds.add(it.AccountId);
                }
            }
            
            if(oldRec != null){
                for(Contact it : oldRec){
                    if(it.AccountId != null)
                        AccountIds.add(it.AccountId);
                }
            }
            
            Map<Id,Account> AccountIdMap = new Map<Id,Account>([SELECT Id,TotalAmount__c FROM Account WHERE Id IN:AccountIds]);
            Map<Id,Account> DupAccountIdMap = new Map<Id,Account>([SELECT Id,TotalAmount__c FROM Account WHERE Id IN:AccountIds]);
            
            
            if(newMap != null){
                for(Contact it:newRec){
                    
                    Account newAcc = new Account();
                    Account oldAcc = new Account();
                    
                    // check if account changed;
                    
                    if(oldMap == null){
                        if(it.AccountId != null && it.Amount__c > 0){
                            
                            newAcc.Id = it.AccountId;
                            newAcc.TotalAmount__c = AccountIdMap.get(it.AccountId).TotalAmount__c + it.Amount__c;
                            
                        }
                    }
                    else if(oldMap.get(it.Id).AccountId != it.AccountId){
                        
                        if(it.AccountId != null ){
                            newAcc.Id = it.AccountId;
                            newAcc.TotalAmount__c = AccountIdMap.get(it.AccountId) + it.Amount__c;
                        }
                        
                        if(oldMap.get(it.Id) != null){
                            oldAcc.Id = oldMap.get(it.Id);
                            oldAcc.TotalAmount__c = AccountIdMap.get(it.AccountId) - oldMap.get(it.Id).Amount__c;
                        }
                    }
                    else if(it.Amount__c != oldMap.get(it.Id).Amount__c){
                        newAcc.Id = it.AccountId;
                        newAcc.TotalAmount__c = AccountIdMap.get(it.AccountId) - oldMap.get(it.Id).Amount__c + it.Amount__c;
                    }
                    
                    if(newAcc.Id != null){
                        AccountIdMap.put(newAcc.Id, newAcc);
                    }
                    
                    if(oldAcc.Id != null){
                        AccountIdMap.put(oldAcc.Id, oldAcc);
                    }
                }
            }
            else if(newMap == null){
                for(Contact it:oldRec){
                    
                    if(it.AccountId != null){
                        
                        Account oldAcc = new Account();
                        oldAcc.Id = it.AccountId;
                        oldAcc.TotalAmount__c = AccountIdMap.get(it.AccountId) - it.Amount__c;
                        AccountIdMap.put(oldAcc.Id, oldAcc);
                        
                    }
                }
            }
            
            for(Account it:AccountIdMap.keySet()){
                if(DupAccountIdMap.get(it.Id).TotalAmount__c != it.TotalAmount__c){
                    AccountUpdate.add(it);
                }
            }
            
            if(!AccountUpdate.isEmpty())
                update AccountUpdate;
            
        }
        catch(Exception err){
            System.debug(err);
        }
        return;
    }
    
    
    private void ChangeAssociatedName(){
        
        List<Contact> UpdateThisContacts = new List<Contact>();
        
        Set<Id> ContactIds = new Set<Id>();
        Set<Id> AccountIds = new Set<Id>();
        
        for(Contact it:newRec){
            if(oldMap.get(it.Id).AccountId != null && it.AccountId!=null && oldMap.get(it.Id).AccountId!=it.AccountId){
                ContactIds.add(it.Account);
                AccountIds.add(oldMap.get(it.Id).AccountId);
            }
        }

        if(ContactIds.isEmpty())
            return;

        Map<Id,Contact> ContactMap = new Map<Id,Contact>([SELECT Id,AccountId FROM Contact WHERE Id NOT IN:ContactIds AND AccountId IN:AccountIds]);
        
        Map<Id,List<Contact>> IdToContactMap = new Map<Id,List<Contact>>();
        
        for(Contact it:ContactMap.values()){
            
            if (!idToContactMap.containsKey(it.AccountId)) 
                idToContactMap.put(it.AccountId, new List<Contact>());
            
            IdToContactMap.get(it.AccountId).add(it);
        }
        
        for(Id it : ContactIds){
            List<Contact> tmp = IdToContactMap.get(oldMap.get(it.Id).AccountId);
            if(tmp == null)
                continue;
            for(Contact up:tmp){
                up.AccountId = it.AccountId;
                UpdateThisContacts.add(up);
            }
        }
        
        if(UpdateThisContacts.isEmpty() == false)
            update UpdateThisContacts;
        
        return;
    }
    
    
    
    private void DivideAllContact(){
        
        
        try{
            
            Set<Id> AccountIds = new Set<Id>();
            
            for(Contact it: newRec)
                if(it.AccountId != null)
                    AccountIds.add(it.AccountId);
            
            Map<Id,Account> AccountMap = new Map<Id,Account>([SELECT Id,maxLimit__c FROM Account WHERE Id IN :AccountIds]);
            
            
            List<Contact> ConactInsert = new List<Contact>();
            
            for(Contact it:newRec){
            
                if(it.AccountId == null)continue;
                
                Account CurrentContactAccount = AccountMap.get(it.AccountId);
                
                if(CurrentContactAccount.maxLimit__c <= 0)continue;
                
                Integer indx = 1;
                Decimal res = (it.Limit__c - CurrentContactAccount.maxLimit__c);
                
                while(res > 0){
                    
                    Decimal tmp = Math.min(res,CurrentContactAccount.maxLimit__c);
                    res -= tmp;
                    
                    Contact newContact = new Contact(LastName=indx + ' New ' + it.LastName , Limit__c=tmp,AccountId=it.AccountId);

                    ConactInsert.add(newContact);
                    
                    indx++;
                    
                }
                
                it.Limit__c = Math.min(CurrentContactAccount.maxLimit__c,it.Limit__c);
                
            }
            
            if(!ConactInsert.isEmpty())
                insert ConactInsert;
            
        }
        catch(Exception err){
            System.debug(err.getMessage());
        }
        return;
    }
    
    
    //  1...     Creating Event When Contact Is created
    
    private void CreateEvents(){
        
        List<Event> EventsAssociatedWithContact = new List<Event>();
        
        try{
            if(isBefore && isInsert){
                for(Contact it : newContacts){
                    if(it.AccountId != null){
                        Event CreatedNewEvent = new Event();
                        
                        createdNewEvent.WhatId = it.Account.Id;
                        createdNewEvent.WhoId = it.Id;
                        createdNewEvent.Subject = 'Contact is Created';
                        createdNewEvent.OwnerId = it.OwnerId;
                        createdNewEvent.StartDateTime = System.now();
                        createdNewEvent.EndDateTime = System.now() + 5;
                        
                        EventsAssociatedWithContact.add(CreatedNewEvent);
                    }
                }
            }
            
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    // 1... Delete related Account only if there is no other contact with that account
    
    private void delContactsAccount(){
        
        List<Account> DeleteAccounts = new List<Account>();
        
        try{
            
            Set<Id> AccountIds = new Set<Id>();
            
            for(Contact it:oldRec)  if(it.Account != null)   AccountIds.add(it.AccountId);
            
            
            Map<Id,Account> AccountMap = new Map<Id,Account>([SELECT Id,Name FROM Account WHERE Id IN :AccountIds]);
            List<Contact> ContactWithAccount = [SELECT Id,AccountId FROM Contact WHERE AccountId IN :AccountMap.keySet()];
            
            Map<Id,Integer> AccToContactCount = new Map<Id,Integer>();
            
            for(Account itAcc:AccountMap.keySet()){
                for(Contact itCon:ContactWithAccount){
                    if(itAcc.Id == itCon.AccountId){
                        if(AccToContactCount.containsKey(itAcc.Id)){
                            AccToContactCount.put(itAcc.Id, 1);
                        }
                        else{
                            AccToContactCount.put(itAcc.Id,AccToContactCount.get(itAcc.Id)+1);
                        }
                    }
                }
            }
            
            for(Account it:AccountMap){
                if(!AccToContactCount.containsKey(it.Id)){
                    DeleteAccounts.add(it);
                }
            }
            
            if(!DeleteAccounts.isEmpty())
                delete DeleteAccounts;
            
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }
}