/**
 * About : Case Hierarchy LWC
 * Discription : Display child case hierarchy
 */
import { LightningElement, api, track } from "lwc";
import getCaseChildRecords from "@salesforce/apex/CaseHierarchyControler.getCaseChildRecords";
const COLUMNS = [
  {
    label: "Case Number",
    type: "url",
    fieldName: "nameUrl",
    typeAttributes: { label: { fieldName: "caseNum" }, target: "_blank" },
    initialWidth: 300
  },
  {
    type: "text",
    fieldName: "subject",
    label: "Subject"
  },
  {
    type: "text",
    fieldName: "origin",
    label: "Origin"
  }
];
export default class CaseHierarchy extends LightningElement {
  @api recordId;
  @track error;
  @api gridColumns = COLUMNS;
  @track gridData;

  /**
   * Method : connectedCallback
   * Discription : loads one level childs case
   */
  connectedCallback() {
    this.fetchCaseRecords(this.recordId, true);
  }

  /**
   * Method : handleRowToggle
   * Discription : handle row action, loads cases on click on toggle
   */
  handleRowToggle(event) {
    const rowName = event.detail.name;
    const hasChildrenContent = event.detail.row.hasChildrenContent;
    console.log(JSON.stringify(event.detail));
    if (!event.detail.hasChildrenContent && event.detail.isExpanded) {
      this.fetchCaseRecords(rowName, false);
    }
  }

  /**
   * Method : fetchCaseRecords
   * Discription : get case data from apex
   */
  fetchCaseRecords(caseId, onLoad) {
    getCaseChildRecords({ parentId: caseId })
      .then((data) => {
        if (data) {
          data = JSON.parse(JSON.stringify(data));
          data.map((e) => {
            e["nameUrl"] = `/${e.caseId}`;
            if (e["hasChildrenContent"]) {
              e["_children"] = [];
            }
          });
          console.log("data::", data);
          if (onLoad) {
            this.gridData = data;
          } else {
            this.gridData = this.getNewDataWithChildren(
              caseId,
              this.gridData,
              data
            );
          }
        }
      })
      .catch((error) => {
        if (error) {
          this.error = "Unknown error";
          if (Array.isArray(error.body)) {
            this.error = error.body.map((e) => e.message).join(", ");
          } else if (typeof error.body.message === "string") {
            this.error = error.body.message;
          }
        }
      });
  }

  /**
   * Method : getNewDataWithChildren
   * Discription : helper method
   */
  getNewDataWithChildren(rowName, data, children) {
    return data.map((row) => {
      let hasChildrenContent = false;
      if (
        Object.prototype.hasOwnProperty.call(row, "_children") &&
        Array.isArray(row._children) &&
        row._children.length > 0
      ) {
        hasChildrenContent = true;
      }

      if (row.caseId === rowName) {
        row._children = children;
      } else if (hasChildrenContent) {
        this.getNewDataWithChildren(rowName, row._children, children);
      }
      return row;
    });
  }
}