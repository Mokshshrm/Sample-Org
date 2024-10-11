trigger SendEmailtoContactIfAccountNameIsUpdated on Account (before update,before insert,after insert,after update) {
    
    if(Trigger.isInsert){
        
        if(Trigger.isBefore){
            
            //  Delete All Account with sames name;
            
            
            //  Insert Mv_Clouds  as prefix in name
            
            List<Account>DuplicateAccounts = new List<Account> ();
            
            for(Account it : Trigger.New){
                
                Account[] DuplicateAccount = [select Id,Name from Account Where Account.Name = :it.Name];
                
                for(Account dup : DuplicateAccount){
                    
                    Boolean isItInClosedWonOrLost = false;
                    Opportunity[] OpportunityWithClosedWonOrLost = [select Id,Name,StageName from Opportunity Where Opportunity.StageName='Closed Lost' or Opportunity.StageName='Closed Won'];
                    
                    if(!OpportunityWithClosedWonOrLost.isEmpty()){
                        for(Opportunity opp:OpportunityWithClosedWonOrLost){
                            System.debug(opp.StageName);
                            if((opp.StageName=='Closed Lost' || opp.StageName=='Closed Won')){
                                isItInClosedWonOrLost = true;
                                break;
                            }
                        }
                    }
                    
                    if(isItInClosedWonOrLost == false)
                        DuplicateAccounts.add(dup);
                }
                
                // it.name = ('Mv_Clouds ' + it.name);
                
            }
            
            if(DuplicateAccounts.isEmpty()==false)
                delete DuplicateAccounts;
            
        }
        
        // if(Trigger.isAfter){
            
        //     // after insert Submit for Approval
        //     // for submit approval process.
            
        //     for(Account it:Trigger.New){
                
        //         if(it.Rating=='Hot'){
                    
        //             Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
        //             approvalRequest.setComments('Offer Submitted for approval');
        //             approvalRequest.setObjectId(it.Id);
        //             Approval.ProcessResult approvalResult = Approval.process(approvalRequest);
                    
        //         }
                
        //     }
            
        //     // created contact whenerver Account is created;
            
        //     List<Contact> ContactListToBeCreated = New LIST<Contact>();
            
        //     for(Account it:Trigger.New){
        //         ContactListToBeCreated.add(new Contact(LastName=it.Name,AccountId= it.Id));
        //     }
            
        //     insert ContactListToBeCreated;
            
        // }
    }
    
    if(Trigger.isUpdate){
        
        
        if(Trigger.isBefore){
            
            List<Messaging.SingleEmailMessage> MailList = new List<Messaging.SingleEmailMessage>();
            
            for(Account it:Trigger.new){
                
                Account oldAccount = Trigger.oldMap.get(it.Id);
                
                if(oldAccount.Name != it.Name ){
                    
                    
                    Contact[] ContactAssociatedWithAccount = [select Email from contact where Contact.Account.Id = :it.Id and Email != null];
                    
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
                        
                        if(!MailList.isEmpty()){
                            Messaging.sendEmail(MailList);
                        }
                    }
                    
                }
                
            }
            
        }
    }
    
    if(Trigger.isAfter){
        
        if(Trigger.isInsert || Trigger.isUpdate){
            
            List<User> UserWhomToShare = new List<User>();
            
            // for(User it : [select Id,Name from User where User.Name='nachos']){
                
                //     if([select Id,UserOrGroupId From AccountShare Where AccountShare.UserOrGroupId=:it.Id].size() == 0){
                    //         UserWhomToShare.add(it);
                //     }
                
            // }
            
            // System.debug(UserWhomToShare.size());
            
            // if(!UserWhomToShare.isEmpty()){
                
                List<Account> ListOfAccountRecords = new List<Account>();
                
                
                for(Account it:Trigger.new){
                    
                    // if(((!Trigger.oldMap.containsKey(It.Id)) ||Trigger.oldMap.get(it.Id).Type != it.Type) && it.Type == 'Hot'){
                        ListOfAccountRecords.add(it);
                    // }
                    
                }
                
                // if(ListOfAccountRecords.isEmpty() == false){
                //     (new SharingAccountObject()).SharingAccountObjectWithUser(ListOfAccountRecords,UserWhomToShare);
                // }
                
            // }
            
        }
    }


}