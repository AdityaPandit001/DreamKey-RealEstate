trigger Lead on Lead (before insert) {
    
    if(trigger.isInsert && trigger.isBefore){
        
        for(lead ld :trigger.new){
                ld.ownerId ='00GdL00000KpcHR';
                        }
        
    }

}