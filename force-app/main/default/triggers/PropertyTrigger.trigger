trigger PropertyTrigger on Property__c (before insert,after insert, before update , after update , before delete , after delete , after undelete) {
    
    
    if(trigger.isBefore){
        if(trigger.isInsert){
            
           propertyTriggerHandler.BeforeInsertValidations(trigger.new);
        }
    }
    
    
    
    
    
    if(trigger.isBefore){
        if(trigger.isUpdate){
           propertyTriggerHandler.checkAgentProfileAndUpdateDefaultCommisionPercentage(trigger.new);
        }
    }
    
    
    if(trigger.isBefore){
        if(trigger.isUpdate){
           propertyTriggerHandler.validateProfileOfManager(trigger.new);
        }
    }
    
    
    
    If(trigger.isAfter){
        if(trigger.isUpdate){
           propertyTriggerHandler.createTaskForSendApproval(trigger.new);
        }
    }
   
    if(trigger.isBefore){
        if(trigger.isUpdate){
           propertyTriggerHandler.updateYearToDateSale(trigger.new);
            
        }
    }
    
    
    
    
    
    if(trigger.isAfter){
        if(trigger.isUpdate){
            propertyTriggerHandler.updateTotalSalesOnAgent(trigger.new);
        }
    }
    
    
    

    if(trigger.isBefore){
        if(trigger.isUpdate){
           propertyTriggerHandler.enforceLimitOnHavingProperty(trigger.new);
        }
    }
    
    
    if(trigger.isBefore){
        if(trigger.isUpdate){
             propertyTriggerHandler.CheckSalesOfficeOfAgent(trigger.new);
        }
    }
    
    if(trigger.isBefore){
        if(trigger.isUpdate){
            for(property__c prop:trigger.new){
                if(prop.status__c=='Closed Approved' && prop.agent__c!=null && prop.sales_price__c !=null
                  && prop.Agent_Commission_Percentage__c !=null && prop.sale_date__c==null){
                    prop.sale_date__c =Date.today();
                }
            }
        }
    }
    
    
    
}