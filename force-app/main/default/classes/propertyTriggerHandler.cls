public class propertyTriggerHandler {
    
    public static void BeforeInsertValidations(list<property__c> newList){
        
         for(Property__c prop:newList){
                if(prop.status__c ==null  && prop.agent__c==null){
                    prop.status__c='Open';
                }
                if(prop.status__c !='open'){
                    prop.addError('Property will be open while creating');
                }
                if(prop.agent__c !=null){
                    prop.addError('Agent cannot be assign to property while creating');
                    
                }
            }
    }

    
    
    
    
    
    public static void checkAgentProfileAndUpdateDefaultCommisionPercentage(list<property__c> newList){
         id profileId=[SELECT Id, Name, ProfileId FROM User WHERE id =: userInfo.getUserId() LIMIT 1].ProfileId;
            string profileName=[SELECT Id, Name FROM Profile WHERE id =:profileId LIMIT 1].Name;
            
            set<id> agentIds = new set<id>();
            for(property__c prop:newList){
                if(prop.Agent__c!=null && prop.Status__c=='Working' && profileName!='DreamKey Agent' && prop.Sales_Price__c==null){
                    prop.addError('you are not valid user to claim the property');
                }
                if(prop.Agent__c!=null && prop.Status__c=='Working' && profileName=='DreamKey Agent'){
                    agentIds.add(prop.Agent__c);
                }
            }
            if(agentIds.size()>0){
                 map<id,agent__c> agentMap = new map<id,agent__c>([SELECT id , Default_Commission_Split__c FROM agent__c
                                                             WHERE id IN: agentIds]);
                if(agentMap.values().size()>0){
                    for(property__c prop:newList){
                         if(prop.Agent__c!=null && prop.Status__c=='Working' && profileName=='DreamKey Agent'){
                            prop.Agent_Commission_Percentage__c= agentMap.get(prop.Agent__c).Default_Commission_Split__c;
                    
                }
                    }
                }
            }
    }
           
        
        
        
        
      public static void validateProfileOfManager(List<Property__c> newList) {
    // Get current user's profile name
    User currentUser = [SELECT Id, Name, Profile.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
    String profileName = currentUser.Profile.Name;

    for (Property__c prop : newList) {
        if (prop.Agent__c != null && prop.Status__c == 'Closed Approved' && profileName != 'System Administrator') {
            prop.addError('You are not a valid user to approve the property');
        }
    }
}
        
        
            
    
    public static void createTaskForSendApproval(list<property__c> newlist){
        
         list<task> taskList = new list<task>();
            for(property__c prop:newlist){
                if(prop.Agent__c!=null && prop.Status__c=='working' && prop.sales_price__c >0){
                    Task newTask = new Task(
                        WhatId = prop.id,
                        Subject = 'SEND FOR APPROVAL',
                        OwnerId = userInfo.getUserId(),  
                        Status = 'In Progress',
                        Description ='Property',
                        Priority = 'High');
                    taskList.add(newTask);
                }
            }
            if(!taskList.isEmpty()){
                insert taskList;
            }
    }
            
    
    
    
    
    public static void updateYearToDateSale(list<property__c> newList){
        
         set<id> agentIds = new set<id>();
             set<id> officeIds = new set<id>();
            for(property__c prop:newList){
                if(prop.Sales_Office__c!=null && prop.Agent__c!=null && prop.status__c=='Closed Approved' && prop.Sales_Price__c!=null){
                    officeIds.add(prop.Sales_Office__c);
                    agentIds.add(prop.Agent__c);
                }
            }
            if(agentIds.size()>0){
                list<agent__c> agentList = new list<agent__c>();
                for(aggregateResult ar:[SELECT agent__c ag ,SUM(sales_price__c) sp FROM property__C
                                       WHERE agent__c IN: agentIds GROUP BY agent__c]){
                                           agent__c agt = new agent__c( Id =(id)ar.get('ag'),
                                                                      Year_to_Date_Total_Sales__c =(decimal)ar.get('sp'));
                                           agentList.add(agt);
                    
                }
                if(agentList.size()>0){
                    update agentList;
                }

            }
            
            if(officeIds.size()>0){
                list<sales_office__c> officeList = new list<sales_office__c>();
                for(aggregateResult ar:[SELECT sales_office__c so ,SUM(sales_price__c) sp FROM property__C
                                       WHERE sales_office__c IN: officeIds GROUP BY sales_office__c]){
                                           sales_office__c soc = new sales_office__c( Id =(id)ar.get('so'),
                                                                      Year_to_date_sales__c =(decimal)ar.get('sp'));
                                           officeList.add(soc);
                    
                }
                if(officeList.size()>0){
                    update officeList;
                }

            }
    }
    
    
    
    public static void updateTotalSalesOnAgent(list<property__c> newList){
        
        set<id> agentIds = new set<id>();
            
            for(property__c prop:newList){
                if(prop.Agent__c!=null && prop.Sales_Price__c!=null && prop.Agent_Commission_Percentage__c!=null &&
                  prop.Agent_Commission_Amount__c!=null && prop.Status__c=='Closed Approved'){
                      //prop.Sale_Date__c = Date.today();

                      agentIds.add(prop.Agent__c);
                }
                
            }
            map<id,agent__c> agentMap = new map<id,agent__c>([SELECT id , Year_to_Date_Total_Commissions__c FROM agent__c
                                                             WHERE id IN: agentIds]);
            if(agentMap.values().size()>0){
                for(property__c prop:newList){
                    agentMap.get(prop.Agent__c).Year_to_Date_Total_Commissions__c += prop.Agent_Commission_Amount__c;
                }
            }
            if(agentMap.values().size()>0){
                update agentMap.values();
            }
    }
    
    
   public static void enforceLimitOnHavingProperty(List<Property__c> newList) {
  set<id> agentids = new set<id>();
       for(property__c prop:newList){
           if(prop.Status__c=='Working' && prop.Agent__c!=null && prop.Sales_Price__c==null ){
               agentIds.add(prop.Agent__c);
           }
       }
       if(agentids.size()>0){
           map<id,integer> countMap = new map<id,integer>();
           for(agent__c ag:[SELECT id , (SELECT id FROM Properties__r WHERE Status__c='Working'  )FROM agent__c]){
                               countMap.put(ag.id,ag.Properties__r.size());
           }
           if(countMap.values().size()>0){
               for(property__c prop:newList){
                   if(countMap.get(prop.Agent__c)>=3){
              
                       prop.addError('you cannot have more than 3 working properties');
           }
               }
           }
           
           
       }
       
}
    
    
    public static void CheckSalesOfficeOfAgent(list<property__c> newList){
        set<id> agentIds = new set<id>(); 
            for(property__c prop:newList){
                if(prop.agent__c !=null && prop.sales_office__c !=null && prop.status__c=='Working'){
                    agentIds.add(prop.agent__c);
                }
            }
            if(!agentIds.isEmpty()){
                map<id,agent__c> agentMap = new map<id,agent__c>();
                for(agent__c agents:[SELECT id , sales_office__c FROM agent__c WHERE  id IN: agentIds]){
                    if(agents.sales_office__c !=null){
                        agentMap.put(agents.id, agents);
                    }
                }
                for(property__c prop:newList){
                     if(prop.agent__c !=null && prop.sales_office__c !=null && prop.status__c=='Working' &&
                       prop.Sales_Office__c != agentMap.get(prop.Agent__c).sales_office__c){
                    prop.addError('you do not belong to the same sales office where this property belongs');
                }
                }
            }
    }

    
    }