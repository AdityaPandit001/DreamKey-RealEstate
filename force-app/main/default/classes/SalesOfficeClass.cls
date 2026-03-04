public with sharing class SalesOfficeClass {
    @AuraEnabled(cacheable=true)
    public static list<property__c> fetchClosePendingProperties(id officeId){
       list<property__c> propertyList =[ SELECT Id,sales_office__c, Property_Name__c, Listing_Price__c, Sales_Price__c, Agent__c, Agent_Commission_Percentage__c FROM Property__c 
       WHERE Status__c='Closed Pending Approval' AND sales_office__c =: officeId];

       return propertyList;
    }

    @AuraEnabled(cacheable=true)
    public static string getOfficeName(id officeId){
     string officeQuery =[ SELECT Name, Id, Sales_Office_Name__c FROM Sales_Office__c WHERE Id =: officeId LIMIT 1].Sales_Office_Name__c;
     return officeQuery;

      
    }

    
    @AuraEnabled(cacheable=true)
    public static decimal getYearToDateSales(id officeId){
     decimal officeQuerySales =[ SELECT Name, Id, Sales_Office_Name__c, Year_to_date_sales__c FROM Sales_Office__c WHERE Id =: officeId LIMIT 1].Year_to_date_sales__c;
     return officeQuerySales;

      
    }

    
    @AuraEnabled
    public static void approveProperties(list<string> searchKey){
      if (searchKey !=null) {
         list<property__c> propertyList =[ SELECT Id,Property_Name__c,agent__c,Status__c, sale_date__c
         FROM Property__c WHERE Id IN:searchKey];

         for(property__c prop:propertyList){
          
            prop.Status__c='Closed Approved';
   
         }
         update propertyList;
     }
    

     }




     
    @AuraEnabled
    public static void rejectProperties(list<string> searchKey){
      if (searchKey !=null) {
         list<property__c> propertyList =[ SELECT Id,Property_Name__c,agent__c,Status__c,Agent_Commission_Percentage__c
         FROM Property__c WHERE Id IN:searchKey];

         for(property__c prop:propertyList){
          prop.agent__c= null;
            prop.Status__c='Withdrawn';
            prop.Agent_Commission_Percentage__c=0;
   
         }
         update propertyList;
     }
    

     }
     
}