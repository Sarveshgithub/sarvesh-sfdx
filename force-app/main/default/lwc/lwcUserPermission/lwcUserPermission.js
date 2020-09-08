import { LightningElement, api, track } from "lwc";
import UserId from "@salesforce/user/Id";
import getUserPermission from "@salesforce/apex/UserPermissionsUtility.getUserPermission";
export default class LwcUserPermission extends LightningElement {
  @track objectAPIName = "Contact";
  @track fieldAPIName = "Field1__c";
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
