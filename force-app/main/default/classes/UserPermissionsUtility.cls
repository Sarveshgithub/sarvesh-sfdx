public with sharing class UserPermissionsUtility {
    
    public UserPermissionsUtility(String userId) {
        for(PermissionSetAssignment psAssign: [SELECT Id,PermissionSetId, PermissionSet.Name,PermissionSet.IsCustom  FROM PermissionSetAssignment where AssigneeId = '0052w000002VemN']){

        }
    }
}
