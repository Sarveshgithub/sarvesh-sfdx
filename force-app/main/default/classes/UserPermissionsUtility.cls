public with sharing class UserPermissionsUtility {
  public static String FIELD_TYPE = 'FIELD';
  public static String OBJECT_TYPE = 'OBJECT';
  public class PermissionWrapper {
    @AuraEnabled
    public String recId { get; set; }
    @AuraEnabled
    public String permType { get; set; }
    @AuraEnabled
    public String profileId { get; set; }
    @AuraEnabled
    public String permissionSetId { get; set; }
    @AuraEnabled
    public Boolean isOwnedByProfile { get; set; }
    @AuraEnabled
    public String permissionSetName { get; set; }
    @AuraEnabled
    public String profileName { get; set; }
    @AuraEnabled
    public List<FieldPermissions> lstFieldPermissions { get; set; }
    @AuraEnabled
    public ObjectPermissions objectPermission { get; set; }
    public PermissionWrapper(
      String recId,
      String permType,
      String profileId,
      String permissionSetId,
      Boolean isOwnedByProfile,
      String permissionSetName,
      String profileName,
      List<FieldPermissions> lstFieldPermissions,
      ObjectPermissions objectPermission
    ) {
      this.recId = recId;
      this.permType = permType;
      this.profileId = profileId;
      this.permissionSetId = permissionSetId;
      this.isOwnedByProfile = isOwnedByProfile;
      this.permissionSetName = permissionSetName;
      this.profileName = profileName;
      this.lstFieldPermissions = lstFieldPermissions;
      this.objectPermission = objectPermission;
    }
  }
  @AuraEnabled
  public static List<PermissionWrapper> getUserPermission(
    List<String> lstObjectName,
    List<String> lstFieldName,
    String userId
  ) {
    List<String> fieldCondition = new List<String>();
    List<String> objectCondition = new List<String>();
    Map<String, PermissionWrapper> mapPermission = new Map<String, PermissionWrapper>();
    String fieldSOQL = 'SELECT Id,SobjectType,Field,ParentId,PermissionsEdit,PermissionsRead,Parent.Name,Parent.IsOwnedByProfile,Parent.ProfileId,Parent.Profile.Name FROM FieldPermissions';
    if (lstObjectName.size() > 0) {
      Integer objCount = 0;
      for (String obj : lstObjectName) {
        lstObjectName[objCount] = '\'' + obj + '\'';
        objCount++;
      }
      fieldCondition.add(
        ' SobjectType IN  (' +
        String.join(lstObjectName, ',') +
        ')'
      );
    }
    if (lstFieldName.size() > 0) {
      Integer objCount = 0;
      for (String obj : lstFieldName) {
        lstFieldName[objCount] = '\'' + obj + '\'';
        objCount++;
      }
      fieldCondition.add(
        ' Field IN  (' +
        String.join(lstFieldName, ',') +
        ')'
      );
    }
    if (fieldCondition.size() > 0) {
      fieldSOQL += ' WHERE ' + String.join(fieldCondition, ' AND ');
    }
    System.debug('fieldSOQL:::' + fieldSOQL);
    for (
      FieldPermissions fieldPerm : (List<FieldPermissions>) Database.query(
        fieldSOQL
      )
    ) {
      if (mapPermission.containsKey(fieldPerm.ParentId)) {
        mapPermission.get(fieldPerm.ParentId)
          .lstFieldPermissions.add(fieldPerm);
      } else {
        mapPermission.put(
          fieldPerm.ParentId,
          new PermissionWrapper(
            fieldPerm.Id,
            FIELD_TYPE,
            fieldPerm.Parent.ProfileId,
            fieldPerm.ParentId,
            fieldPerm.Parent.IsOwnedByProfile,
            fieldPerm.Parent.Name,
            fieldPerm.Parent.Profile.Name,
            new List<FieldPermissions>{ fieldPerm },
            null
          )
        );
      }
    }
    return mapPermission.values();
  }
}
