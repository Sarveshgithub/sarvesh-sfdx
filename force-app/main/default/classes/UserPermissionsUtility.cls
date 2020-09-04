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
