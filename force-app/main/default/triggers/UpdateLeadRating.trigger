trigger UpdateLeadRating on Lead (before insert) {
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            for(Lead it : Trigger.new){
                System.debug('Found ' + it.Id);
                it.Rating = 'Hot';
            }
        }
    }
    System.debug('Done');
}