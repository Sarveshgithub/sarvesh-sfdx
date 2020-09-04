import { LightningElement, api, track } from "lwc";
import UserId from "@salesforce/user/Id";
import getUserPermission from "@salesforce/apex/UserPermissionsUtility.getUserPermission";
export default class LwcUserPermission extends LightningElement {
  @track objectAPIName = "Contact";
  @track fieldAPIName = "Field1__c";
  handleSearch(event) {
    console.log(
      "object name and field name",
      this.objectAPIName,
      this.fieldAPIName,
      UserId
    );
    getUserPermission({
      objectName: this.objectAPIName,
      fieldAPI: this.fieldAPIName,
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
