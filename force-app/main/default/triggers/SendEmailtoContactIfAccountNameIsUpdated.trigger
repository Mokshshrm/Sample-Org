trigger SendEmailtoContactIfAccountNameIsUpdated on Account (before update,before insert,after insert,after update) {
    
    Trigger_SendEmailWhenAccountNameUpdate obj = new Trigger_SendEmailWhenAccountNameUpdate(Trigger.isAfter,Trigger.isBefore,Trigger.isInsert,Trigger.isUpdate,Trigger.isDelete,Trigger.isUndelete,Trigger.new,Trigger.newMap,Trigger.old,Trigger.oldMap);
    
    System.debug('Account');
    
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            System.debug('3');
            obj.DeleteDuplicate(Trigger.new);
        }
        if(Trigger.isAfter){
            System.debug('4');
            obj.sendForApprovalProcessAndCreateContact(Trigger.new);
        }
    }
    
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            System.debug('5');
            obj.sendEmaisToContact(Trigger.new, Trigger.oldMap);
        }
    }
    
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            System.debug('6');
            obj.ShareAccountsRecords(Trigger.new,Trigger.oldMap);
        }
    }
    
}