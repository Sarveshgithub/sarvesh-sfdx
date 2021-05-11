import { LightningElement, api, track } from "lwc";
import UserId from "@salesforce/user/Id";
import getUserPermission from "@salesforce/apex/UserPermissionsUtility.getUserPermission";
export default class LwcUserPermission extends LightningElement {
  @track fieldCols = [
    { label: "Field", fieldName: "Field", type: "text" },
    {
      label: "PermissionsEdit",
      fieldName: "PermissionsEdit",
      type: "boolean"
    },
    {
      label: "PermissionsRead",
      fieldName: "PermissionsRead",
      type: "boolean"
    }
  ];
  @track objectCols = [
    { label: "Object", fieldName: "SobjectType", type: "text" },
    {
      label: "PermissionsRead",
      fieldName: "PermissionsRead",
      type: "boolean"
    },
    {
      label: "PermissionsCreate",
      fieldName: "PermissionsCreate",
      type: "boolean"
    },
    {
      label: "PermissionsEdit",
      fieldName: "PermissionsEdit",
      type: "boolean"
    },
    {
      label: "PermissionsDelete",
      fieldName: "PermissionsDelete",
      type: "boolean"
    },
    {
      label: "PermissionsViewAllRecords",
      fieldName: "PermissionsViewAllRecords",
      type: "boolean"
    },
    {
      label: "PermissionsModifyAllRecords",
      fieldName: "PermissionsModifyAllRecords",
      type: "boolean"
    }
  ];
  @track objectAPIName = "Contact";
  @track fieldAPIName = "contact.Field1__c,contact.Field2__c,contact.Email";
  @track profile;
  @track permessionSet;
  @track data;
  handleSearch(event) {
    let objList = this.objectAPIName.replace(/\s/g, "").split(","),
      fieldList = this.fieldAPIName.replace(/\s/g, "").split(",");
    console.log("objList:::", objList);
    console.log("fieldList:::", fieldList);
    console.log("object name and field name", objList, fieldList, UserId);
    getUserPermission({
      lstObjectName: objList,
      lstFieldName: fieldList,
      userId: "0052w000002VemN"
    })
      .then((data) => {
        console.log("data::", JSON.parse(JSON.stringify(data)));
        this.data = JSON.parse(JSON.stringify(data));
      })
      .catch((error) => {});
  }
  handleObjectName(event) {
    this.objectAPIName = event.target.value;
  }
  handleFieldName(event) {
    this.fieldAPIName = event.target.value;
  }
  @api isValid() {
    if (this.required) {
      this.template.querySelector("lightning-input-field").reportValidity();
    }
  }
}