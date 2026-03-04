trigger TaskTrigger on Task (before insert, after insert, before update , after update , before delete , after delete , after undelete) {

    if(trigger.isAfter){
        if(trigger.isUpdate){
            set<id> propertyIds = new set<id>();
            for(task tsk:trigger.new){
                if(tsk.description=='Property' && tsk.status=='Completed' && tsk.WhatId!=null){
                    propertyIds.add(tsk.WhatId);
                }
            }
            list<property__c> propertyList = [SELECT id, status__c FROM property__c WHERE id IN: propertyIds];
            for(property__c prop:propertyList){
                prop.status__c ='Closed Pending Approval';
            }
            if(!propertyList.isEmpty()){
                update propertyList;
            }
        }
    }
}