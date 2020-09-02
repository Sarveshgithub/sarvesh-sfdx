public class NHS_NotificationController {
    public static String route;
    public static final String POST_METHOD = 'POST';
    public static final String EMAIL_ROUTE = 'email';
    public static final String SMS_ROUTE = 'sms';
    
    @InvocableMethod
    public static void notifyServices(List<NHS_NotifyRequestBody> notifyPayload) {
        System.debug('notifyPayload::::'+JSON.serialize(notifyPayload));
        calloutNotificationAPI('email',null,'POST',JSON.serialize(notifyPayload));
    }
    public static void sendEmailSMSNotification(){
        sendEmailNotification();
        sendSMSNotification();
    }
    public static void sendEmailNotification(){
        calloutNotificationAPI('email',null,'POST','df');
    }
    
    public static void sendSMSNotification(){
        calloutNotificationAPI('sms',null,'POST','sdf');
    }
    
    public static void calloutNotificationAPI(String route ,String queryParams,String method,String body){
        HttpRequest req = new HttpRequest();
        String endPoint = 'callout:MuleAPI';
        if(String.isNotBlank(route)){
            endPoint+='/'+route;
        }
        if(String.isNotBlank(queryParams)){
            endPoint+=queryParams;
        }
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setMethod(method);
        req.setBody(body); 
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('response:::'+res.getBody());
    }  
}