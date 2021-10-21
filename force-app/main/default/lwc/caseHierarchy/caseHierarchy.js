import { LightningElement, api, track } from "lwc";
import getCaseChildRecords from "@salesforce/apex/CaseHierarchyControler.getCaseChildRecords";
const EXAMPLES_COLUMNS_DEFINITION_BASIC = [
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
  // definition of columns for the tree grid
  @api gridColumns = EXAMPLES_COLUMNS_DEFINITION_BASIC;
  // data provided to the tree grid
  @track gridData;
  connectedCallback() {
    getCaseChildRecords({ parentId: this.recordId })
      .then((data) => {
        if (data) {
          data = JSON.parse(JSON.stringify(data));
          data.map((e) => {
            e["nameUrl"] = `/${e.caseId}`;
            if (e["hasChildrenContent"]) {
              e["_children"] = [];
            }
            //delete e["hasChildrenContent"];
          });
          console.log("data::::", data);
          this.gridData = data;
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
          console.log("error", this.error);
        }
      });
  }

  handleRowToggle(event) {
    const rowName = event.detail.name;
    const hasChildrenContent = event.detail.row.hasChildrenContent;
    console.log("id::", event.detail.row.hasChildrenContent);
    console.log(JSON.stringify(event.detail));
    // if (!event.detail.hasChildrenContent && event.detail.isExpanded) {
      getCaseChildRecords({ parentId: rowName })
        .then((data) => {
          if (data) {
            data = JSON.parse(JSON.stringify(data));
            console.log("data:::", data);
            data.map((e) => {
              e["nameUrl"] = `/${e.caseId}`;
              if (e["hasChildrenContent"]) {
                e["_children"] = [];
              }
            });
            this.gridData = this.getNewDataWithChildren(
              rowName,
              this.gridData,
              data
            );
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
            console.log("error", this.error);
          }
        });
      //   this.data = getNewDataWithChildren(rowName, this.data, newChildren);
    // }
  }

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
