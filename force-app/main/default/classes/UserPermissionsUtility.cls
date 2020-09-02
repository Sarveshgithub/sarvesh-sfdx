public class NHS_NotificationController {
  public static String route;
  public static final String POST_METHOD = 'POST';
  public static final String EMAIL_ROUTE = '/email';
  public static final String SMS_ROUTE = '/sms';
  public static final String MULE_END_POINT = 'callout:NotifyMuleAPI';
  public static final String CONTENT_TYPE = 'Content-Type';
  public static final String BODY_TYPE = 'application/json;charset=UTF-8';

  @InvocableMethod
  public static List<NHS_NotifyResponseBody> notifyServices(
    List<NHS_NotifyRequestBody> notifyPayload
  ) {
    List<NHS_NotifyResponseBody> responseList = new List<NHS_NotifyResponseBody>();
    System.debug('notifyPayload::::' + JSON.serialize(notifyPayload));
    if (notifyPayload.size() == 1) {
      Map<String, Object> notifyBody = new Map<String, Object>();
      String refrence =
        DateTime.now().format() +
        '_' +
        notifyPayload[0].recordId +
        '_' +
        notifyPayload[0].notification_type +
        '_' +
        notifyPayload[0].template_id;
      if (notifyPayload[0].notification_type == 'SMS') {
        notifyBody.put('phone_number', notifyPayload[0].phone_number);
      } else if (notifyPayload[0].notification_type == 'Email') {
        notifyBody.put('email_address', notifyPayload[0].email_address);
      }
      notifyBody.put('template_id', notifyPayload[0].template_id);
      notifyBody.put('reference', refrence);
      String body = JSON.serialize(notifyBody);
      System.debug('finalPayload:::' + body);
      HTTPResponse response = calloutMuleAPI(
        EMAIL_ROUTE,
        null,
        POST_METHOD,
        body
      );
      System.debug('response:::' + response);
      if (response != null && response.getBody() != null) {
        NHS_NotifyResponseBody responseBody = (NHS_NotifyResponseBody) System.JSON.deserialize(
          response.getBody(),
          NHS_NotifyResponseBody.class
        );
        if (response.getStatusCode() == 200) {
          responseBody.status = 'success';
        } else {
          responseBody.status = 'error';
        }
        responseList.add(responseBody);
        System.debug('responseList:::' + responseList);
        return responseList;
      }
    }
    return responseList;
  }
  public static HTTPResponse calloutMuleAPI(
    String route,
    String queryParams,
    String method,
    String body
  ) {
    HttpRequest req = new HttpRequest();
    String endPoint = MULE_END_POINT;
    if (String.isNotBlank(route)) {
      endPoint += route;
    }
    if (String.isNotBlank(queryParams)) {
      endPoint += queryParams;
    }
    req.setEndpoint(endPoint);
    req.setHeader(CONTENT_TYPE, BODY_TYPE);
    req.setMethod(method);
    req.setBody(body);
    Http http = new Http();
    HTTPResponse res = http.send(req);
    return res;
  }
}
