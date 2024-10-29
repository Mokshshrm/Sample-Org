public with sharing class Trigger_SendEmailWhenAccountNameUpdate {

    static Boolean run = true;
    
    Boolean isBefore, isAfter, isInsert, isUpdate, isDelete,isUndelete;
    List<Contact> newRec,oldRec;
    Map<Id,Contact> newMap, oldMap;
    
    
    public Trigger_SendEmailWhenAccountNameUpdate(Boolean isBefore,Boolean isAfter,Boolean isInsert,Boolean isUpdate,Boolean isDelete,Boolean isUndelete,List<Contact> newRec,Map<Id,Contact> newMap,List<Contact> oldRec,Map<Id,Contact> oldMap){
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
    }
    
    public void beforeInsert(){
    }
    
    public void beforeUpdate(){
    }
    
    public void afterUpdate(){
        sendEmaisToContact();
    }
    
    public void beforeDelete(){
        
    }
    
    public void afterDelete(){
    }
    
    
    
    
    private void DeleteDuplicate(List<Account> newAccount){
        
        List<Account> DuplicateAccounts = new List<Account> ();
        Account[] DuplicateAccount = [select Id,Name from Account Where Account.Name = :it.Name];
        Opportunity[] OpportunityWithClosedWonOrLost = [select Id,Name,StageName from Opportunity Where Opportunity.StageName='Closed Lost' or Opportunity.StageName='Closed Won'];
        
        
        
        if(DuplicateAccounts.isEmpty()==false)
            delete DuplicateAccounts;
    }
    
    private void sendForApprovalProcessAndCreateContact(List<Account> newAccounts){
        
        try{
            
            List<Approval.ProcessSubmitRequest> approvalReq = new List<Approval.ProcessSubmitRequest>();
            
            for(Account it:newRec){
                
                // condition for approval process checking 🤡
                if(it.Rating == 'Hot'){
                    
                    Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                    approvalRequest.setComments('Offer Submitted for approval');
                    approvalRequest.setObjectId(it.Id);
                    approvalReq.add(approvalRequest);
                }
                
            }
            
            
            List<Contact> ContactListToBeCreated = New LIST<Contact>();
            
            for(Account it:newAccounts){
                ContactListToBeCreated.add(new Contact(LastName=it.Name,AccountId=it.Id));
            }
            
            if(!approvalReq.isEmpty())
                Approval.ProcessResult approvalResult = Approval.process(approvalReq);
            
            if(!ContactListToBeCreated.isEmpty())
                insert ContactListToBeCreated;
        }
        catch (Exception err){
            System.debug(err.getMessage());
        }
    }
    
    private void sendEmaisToContact(List<Account> newAccount,Map<Id,Account> oldMap){
        try{
            
            List<Messaging.SingleEmailMessage> MailList = new List<Messaging.SingleEmailMessage>();
            
            Set<Id> AccountsIds = new Set<Id>();
            
            for(Account it:newRec)  AccountsIds.add(it.Id);
            
            Contact[] ContactAssociatedWithAccount = [SELECT Id,Email FROM contact WHERE Contact.AccountId IN :AccountsIds AND Email != null];
            
            for(Account it:newRec){
                
                Account oldAccount = oldMap.get(it.Id);
                
                if(oldAccount.Name != it.Name){
                    
                    List<String> EmailList = new List<String>();
                    
                    if(!ContactAssociatedWithAccount.isEmpty()){
                        for(Contact record : ContactAssociatedWithAccount){
                            EmailList.add(record.Email);
                        }
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        mail.setToAddresses(EmailList);
                        mail.setSubject('Your Account is Name Is Updated');
                        
                        String body = '';
                        body = 'Dear contact of ' + it.Name;
                        body += 'Your Account is Update from' + oldAccount.name + ' to ' + it.Name;
                        mail.setHtmlBody(body);
                        
                        MailList.add(mail);
                        
                    }
                }
            }
            
            if(!MailList.isEmpty())
                Messaging.sendEmail(MailList);
        }
        catch(Exception err){
            System.debug(err.getMessage());
        }
    }
    
    private void ShareAccountsRecords(List<Account> newAccounts,Map<Id,ACcount> oldMap){
        
        try{
            
            List<User> UserWhomToShare =  [select Id,Name from User where User.Name='nachos'];
            
            Set<Id> AccountIds = new Set<Id>();
            
            for(Account it:newRec)
                AccountIds.add(it.Id);
            
            Map<Id,AccountShare> AccountShareRecords = new Map<Id,AccountShare>([SELECT Id,UserOrGroupId FROM AccountShare WHERE AccountId IN :AccountIds]);
            
            Map<Id,AccountShare> userMapAccountShare = new Map<Id,AccountShare>();
            
            for(AccountShare it:AccountShareRecords.values()){
                userMapAccountShare.put();
            }
            
            for(User it:UserWhomToShare){
                
            }
            
            List<Account> ListOfAccountRecords = new List<Account>();
            List<AccountShare> RecordForSharing = new List<AccountShare>();
            
            // List<Integer> tmp = new List<Integer>();Tri
            
            for(User it : UserWhomToShare){
                
                for(Account AccountIt : ListOfAccountRecords){
                    
                    AccountShare newShareRec = new AccountShare();
                    
                    newShareRec.AccountId = (AccountIt.Id);
                    newShareRec.UserOrGroupId = it.Id;
                    
                    newShareRec.AccountAccessLevel = ('read');
                    newShareRec.OpportunityAccessLevel = ('read');
                    newShareRec.CaseAccessLevel = ('read');
                    
                    newShareRec.RowCause = Schema.SObjectType.AccountShare.Manual;
                    
                    
                    RecordForSharing.add(newShareRec);
                    
                }
            }
            
            if(!RecordForSharing.isEmpty())
                insert RecordForSharing;
        }
        catch(Exception err){
            System.debug(err.getMessage());
        }
    }
}