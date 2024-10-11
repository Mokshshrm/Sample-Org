trigger DelteAccountIfContactIsDelted on Contact (before delete, after insert,after update, before insert, before update) {
    
    // if(Trigger.isInsert){
        //     if(Trigger.isAfter){
            //         List<Event>EventsAssociatedWithContact = new List<Event>();
            
            //         for(Contact it : Trigger.new){
                //             if(it.AccountId != null){
                    
                    //                 Event CreatedNewEvent = new Event();
                    //                 createdNewEvent.WhatId = it.Account.Id;
                    //                 createdNewEvent.WhoId = it.Id;
                    //                 createdNewEvent.Subject = 'Contact is Created';
                    //                 createdNewEvent.OwnerId = it.OwnerId;
                    //                 createdNewEvent.StartDateTime = System.now();
                    //                 createdNewEvent.EndDateTime = System.now() + 5;
                    //                 EventsAssociatedWithContact.add(CreatedNewEvent);
                    
                //             }
            //         }
            //         insert EventsAssociatedWithContact;
        //     }
    // }
    // else if(Trigger.isDelete){
        
        //     if(Trigger.isBefore){
            
            //         for(Contact record:Trigger.old){
                
                
                //             if(record.Account.Id != null){
                    
                    //                 // Account tmper = [select Id from Account where Id = :record.AccountId];
                    
                    //                 //  delete tmper;
                    
                    //                 Account[] accountList = [select Id,Name from Account where Account.Id = :record.Account.Id];
                    
                    //                 if(accountList.size() == 1){
                        //                     delete accountList;
                    //                 }
                    
                //             }
            //         }
        //     }
    // }
    
    // (Trigger.isBefore && Trigger.isDelete) ||
    
    
    // Roll-Up Summary On Account TotalAmount__c
    
    RollUpSummaryOnAccount RollUpOBj = new RollUpSummaryOnAccount();
    
    if((Trigger.isAfter && Trigger.isUpdate) || (Trigger.isAfter && Trigger.isInsert)){
        RollUpOBj.CalCulateRollUpSummary(Trigger.new, Trigger.oldMap, Trigger.newMap);
    }
    
    //  Contact Account_Name is Changed Will be Automatically Change all Parent Account Associated Values
    
    if((Trigger.isUpdate && Trigger.isAfter)){
        RollUpOBj.ChangeAssociatedName(Trigger.new, Trigger.oldMap);
        // RollUpOBj.UpdateAccountRecords();
    }
    
    if((Trigger.isInsert && Trigger.isBefore) || (Trigger.isUpdate && Trigger.isBefore)){
        RollUpOBj.HandleAllYourMess(Trigger.new,Trigger.oldMap);
    }
    
    // If Contact Limit Exceed from Account maxLimit Will be Distributed Within maxLimit ;
    
    
}