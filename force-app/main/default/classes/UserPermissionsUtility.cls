public with sharing class UserPermissionsUtility {
  public static String FIELD_TYPE = 'FIELD';
  public static String OBJECT_TYPE = 'OBJECT';
  public class PermissionWrapper {
    @AuraEnabled
    public String Id;
    @AuraEnabled
    public String permType;
    @AuraEnabled
    public String profileId;
    @AuraEnabled
    public String permissionSetId;
    @AuraEnabled
    public Boolean isOwnedByProfile;
    @AuraEnabled
    public String permissionSetName;
    @AuraEnabled
    public String profileName;
    @AuraEnabled
    public List<FieldPermissions> lstFieldPermissions;
    @AuraEnabled
    public ObjectPermissions objectPermission;
  }
  @AuraEnabled
  public static List<PermissionSet> getUserPermission(
    String objectName,
    String fieldAPI,
    String userId
  ) {
    Map<String, PermissionWrapper> mapPermission = new Map<String, PermissionWrapper>();
    for (FieldPermissions fieldPerm : [
      SELECT
        Id,
        SobjectType,
        Field,
        ParentId,
        Parent.Name,
        Parent.IsOwnedByProfile,
        Parent.ProfileId,
        Parent.Profile.Name
      FROM FieldPermissions
      WHERE Field = :fieldAPI AND SobjectType = :objectName
    ]) {
      if (mapPermission.containsKey(fieldPerm.ParentId)) {
      } else {
        mapPermission.put(
          fieldPerm.ParentId,
          new PermissionWrapper(
            fieldPerm.Id,
            FIELD_TYPE,
            fieldPerm.Parent.ProfileId,
            fieldPerm.ParentId,
            Boolean.valueOf(fieldPerm.Parent.IsOwnedByProfile),
            fieldPerm.Parent.Name,
            fieldPerm.Parent.Profile.Name,
            new List<FieldPermissions>{ fieldPerm },
            null
          )
        );
      }
    }
    return null;
  }
}
