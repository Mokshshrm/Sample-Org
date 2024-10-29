trigger DelteAccountIfContactIsDelted on Contact (before delete, after insert,after update, before insert, before update) {
    
    Trigger_DeleteAccount RollUpOBj = new Trigger_DeleteAccount(Trigger.isAfter,Trigger.isBefore,Trigger.isInsert,Trigger.isUpdate,Trigger.isDelete,Trigger.isUndelete,Trigger.new,Trigger.newMap,Trigger.old,Trigger.oldMap);
    
    if(Trigger.isInsert){
        if(Trigger.isAfter){
            RollUpOBj.afterInsert();
        }
        else{
            RollUpOBj.beforeInsert();
        }
    }
    else if(Trigger.isDelete){
        if(Trigger.isAfter){
            RollUpOBj.afterDelete();
        }
        else{
            
        }
    }
    else if(Trigger.isUpdate){
        if(Trigger.isAfter){
            RollUpOBj.afterUpdate();
        }
        else{
            RollUpOBj.beforeUpdate();
        }
    }
    else if(Trigger.isUndelete){
        if(Trigger.isBefore){
            
        }
        else{
            
        }
    }
}