public class Test_Flow {
    @InvocableMethod
    public static void flowData(List<NHS_NotifyRequestBody> conData)
    {
        NHS_NotificationController.calloutNotificationAPI('email',null,'POST',JSON.serialize(conData));
        System.debug('conData::::'+JSON.serialize(conData));
    }
    
    public class FlowInputs{
        @InvocableVariable
        public String route;
        @InvocableVariable
        public String email_address;
        @InvocableVariable
        public String phone_number;
        @InvocableVariable
        public String template_id;        
    }
}