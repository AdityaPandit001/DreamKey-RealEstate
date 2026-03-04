public with sharing class PropertyClass {
    @AuraEnabled(cacheable=true)
    public static list<property__c> fetchOpenProperties(){
           
       list<property__c> propertyList =[ SELECT Id, Property_Name__c,Property_City__c, Sales_Office__r.Sales_Office_Name__c, Listing_Price__c, Status__c, CreatedDate FROM Property__c
        WHERE Status__c='Open' OR Status__c='Withdrawn'  ];

       return propertyList;
    }

   

    @AuraEnabled
    public static void claimProperties(list<string> searchKey){
      if (searchKey !=null) {
         list<property__c> propertyList =[ SELECT Id,Property_Name__c,agent__c,Status__c
         FROM Property__c WHERE Id IN:searchKey];

         Agent__c agents = [SELECT Id, Name, Agent__c FROM Agent__c WHERE Agent__c =:userInfo.getUserId() LIMIT 1];


         for(property__c prop:propertyList){
          prop.agent__c= agents.Id;
            prop.Status__c='Working';
   
         }
         update propertyList;
     }
    

     }


     @AuraEnabled
    public static void claimSingleProperties(string searchKey){
      if (searchKey !=null) {
         property__c prop =[ SELECT Id,Property_Name__c,agent__c,Status__c
         FROM Property__c WHERE Id =:searchKey LIMIT 1];

         Agent__c agents = [SELECT Id, Name, Agent__c FROM Agent__c WHERE Agent__c ='005dL00000DpjoPQAR' LIMIT 1];

         if(prop !=null && agents!=null){

            prop.agent__c= agents.Id;
            prop.Status__c='Working';
   
        
         update prop;
         }
         
     }
    

     }

     
      
     
}