public with sharing class UserPermissionsUtility {
  public UserPermissionsUtility(
    String objectName,
    String fieldAPI,
    String userId
  ) {
    for (PermissionSetAssignment psAssign : [
      SELECT Id, PermissionSetId, PermissionSet.Name, PermissionSet.IsCustom
      FROM PermissionSetAssignment
      WHERE AssigneeId = '0052w000002VemN'
    ]) {
    }
  }
}
