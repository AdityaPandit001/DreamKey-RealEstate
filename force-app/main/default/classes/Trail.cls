public with sharing class Trail {
    @AuraEnabled
    public static void claimProperties(list<string> searchKey){
      if (searchKey !=null) {
         list<property__c> propertyList =[ SELECT Id,Property_Name__c,agent__c,Status__c
         FROM Property__c WHERE Id IN:searchKey];

         Agent__c agents = [SELECT Id, Name, Agent__c FROM Agent__c WHERE Agent__c ='005dL00000DpjoPQAR' LIMIT 1];


         for(property__c prop:propertyList){
          prop.agent__c= agents.Id;
            prop.Status__c='Working';
   
         }
         update propertyList;
     }
    

     }
}