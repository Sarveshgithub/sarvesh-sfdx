public with sharing class UserPermissionsUtility {
  @AuraEnabled
  public static List<PermissionSet> UserPermissionsUtility(
    String objectName,
    String fieldAPI,
    String userId
  ) {
    return [
      SELECT
        id,
        Profile.Name,
        Label,
        Description,
        Name,
        IsOwnedByProfile,
        PermissionsTransferAnyLead,
        (
          SELECT
            SobjectType,
            PermissionsCreate,
            PermissionsDelete,
            PermissionsEdit,
            PermissionsRead,
            PermissionsModifyAllRecords,
            PermissionsViewAllRecords
          FROM ObjectPerms
          WHERE SobjectType = :objectName
        ),
        (
          SELECT SobjectType, Field, PermissionsRead, PermissionsEdit
          FROM FieldPerms
          WHERE SobjectType = :objectName
        )
      FROM PermissionSet
      WHERE isOwnedByProfile = FALSE
    ];
  }
}
