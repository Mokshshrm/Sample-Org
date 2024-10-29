public with sharing class Trigger_OpportunityUpdaCloseDateAndStage {
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
    }
    
    public void beforeInsert(){
        add15DaysANDChangeStage();
    }
    
    public void beforeUpdate(){
    }
    
    public void afterUpdate(){
        CreateStageChangeTask();
    }
    
    public void beforeDelete(){
        
    }
    
    public void afterDelete(){
    }
    
    private void add15DaysANDChangeStage(){
        
        for(opportunity it : newRec){
            
            it.StageName = 'Prospecting';
            it.Type = 'New Customer';
            it.CloseDate = System.today() + 15;
        }
        return;
    }
    
    private void CreateStageChangeTask(){
        
        try{
            
            List<Task> TaskRecords = new List<Task>();
            
            for(opportunity it : newRec){
                
                Opportunity oldOppo = oldMap.get(it.Id);
                
                if(oldOppo != null && oldOppo.Name != it.Name && it.StageName != 'Closed Won' && it.StageName != 'Closed Lost'){
                    
                    Task currentTask = new Task();
                    
                    currentTask.OwnerId = it.OwnerId;
                    currentTask.whatId = it.Id;
                    currentTask.Status = 'Not Started';
                    currentTask.Subject = 'Checkout';
                    currentTask.Priority = 'Normal';
                    currentTask.ActivityDate = System.Today() + 2;
                    
                    TaskRecords.add(currentTask);
                    
                }
                
            }

            if(!TaskRecords.isEmpty())
                insert TaskRecords;
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
        
        return;
    }
    
}