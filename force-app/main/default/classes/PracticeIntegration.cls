public class PracticeIntegration {
    
    public static AccessTokenWrapper getAccess(){
        RequestAccess__mdt accessDetails =[ SELECT Cons__c, Consumer_Secret__c, Password__c,Username__c FROM RequestAccess__mdt LIMIT 1];
        string consumerKey =accessDetails.Cons__c;
        string consumerSecret =accessDetails.Consumer_Secret__c;
        string userName =accessDetails.Username__c;
        string passWord = accessDetails.Password__c;
        string pass =passWord+'ndNpl8ibTawnyHO8SBKdPvXBs';
        
        httpRequest req = new httpRequest();
        req.setEndPoint('https://login.salesforce.com/services/oauth2/token');
        
        string requestBody ='grant_type=password'+'&client_id='+consumerKey+'&client_secret='+consumerSecret+'&username='+userName+'&password='+pass;        
        req.setBody(requestBody);
        
         req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        
        http http = new http();
        httpResponse response=http.send(req);
        system.debug(response.getbody());
        
         AccessTokenWrapper token = (AccessTokenWrapper)JSON.deserialize(response.getBody(),AccessTokenWrapper.class);
        system.debug(token);
        return token;

        
        
            }
    
    
   public class AccessTokenWrapper{
       public String access_token;	//SESSION_ID_REMOVED
       public String instance_url;	//https://cloudintellect-43a-dev-ed.develop.my.salesforce.com
       public String id;	//https://login.salesforce.com/id/00DNS000000MZlX2AW/005NS000000ErIzYAK
       public String token_type;	//Bearer
       public String issued_at;	//1740988031554
       public String signature;	//576jROwyLIxjRi7Cquy+I8QyZZqO2R3n7zCier4mCmk=
        
    }
    
    
    public static void makeGetCall(){
        AccessTokenWrapper access =getAccess();
        if(access?.access_token!=null){
            httpRequest req = new httpRequest();
            string endPoint =access.instance_url+'/services/apexrest/practice';
            endPoint = endPoint+'?name=zoro';
            req.setEndpoint(endPoint);
            req.setMethod('GET');
            req.setHeader('Contend-Type','application/json');
            req.setHeader('Authorization','Bearer '+access.access_token);
            
            http sender = new http();
            httpResponse response=sender.send(req);
            system.debug(response);
            system.debug(response.getBody());
            
        }
    }
    
    
     public static void makedeleteCall(){
        AccessTokenWrapper access =getAccess();
        if(access?.access_token!=null){
            httpRequest req = new httpRequest();
            string endPoint =access.instance_url+'/services/apexrest/practice';
            endPoint = endPoint+'?name=zoro';
            req.setEndpoint(endPoint);
            req.setMethod('DELETE');
            req.setHeader('Contend-Type','application/json');
            req.setHeader('Authorization','Bearer '+access.access_token);
            
            http sender = new http();
            httpResponse response=sender.send(req);
            system.debug(response);
            system.debug(response.getBody());
            
        }
    }
    
    
     public static void makePostCall(){
        AccessTokenWrapper access =getAccess();
        if(access?.access_token!=null){
            httpRequest req = new httpRequest();
            string endPoint =access.instance_url+'/services/apexrest/practice';
           // endPoint = endPoint+'?name=zoro';
            req.setEndpoint(endPoint);
            req.setMethod('POST');
            req.setHeader('Contend-Type','application/json');
            req.setHeader('Authorization','Bearer '+access.access_token);
            
            map<string,object> dataObject = new map<string,object>();
            dataObject.put('name','Luffy');
            dataObject.put('rating','cold');
            
            req.setBody(Json.serialize(dataObject));
            
            http sender = new http();
            httpResponse response=sender.send(req);
            system.debug(response);
            system.debug(response.getBody());
            
        }
    }
    
    
    
     public static void makePatchCall() {
    try {
        // Retrieve the access token
        AccessTokenWrapper access = getAccess();
        
        if (access?.access_token != null) {
            HttpRequest req = new HttpRequest();
            String endPoint = access.instance_url + '/services/apexrest/practice';
             endPoint = endPoint+'?name=sanji';
            
            req.setEndpoint(endPoint);
            req.setMethod('PATCH'); // Changed from POST to PATCH
            req.setHeader('Content-Type', 'application/json'); // Fixed typo
            req.setHeader('Authorization', 'Bearer ' + access.access_token);
            
            // Creating JSON body
            Map<String, Object> dataObject = new Map<String, Object>();
            dataObject.put('name', 'Sanji');
            dataObject.put('rating', 'hot');
            
            req.setBody(JSON.serialize(dataObject));
            
            Http sender = new Http();
            HttpResponse response = sender.send(req);
            
            // Log Response
            System.debug('Response Status: ' + response.getStatus());
            System.debug('Response Body: ' + response.getBody());
            
            // Handling API Errors
            if (response.getStatusCode() >= 400) {
                System.debug('API Error: ' + response.getBody());
            }
        } else {
            System.debug('Error: Access Token is null');
        }
        
    } catch (Exception e) {
        System.debug('Exception: ' + e.getMessage());
    }
}

    
    
    
    
    
    
    

}