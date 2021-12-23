import { LightningElement, track } from "lwc";
import getCurrentlyScheduledCron from "@salesforce/apex/LWCSchedulerInvoiceJobController.getCurrentlyScheduleCron";
import scheduleJob from "@salesforce/apex/LWCSchedulerInvoiceJobController.scheduleJob";
import deleteScheduledJob from "@salesforce/apex/LWCSchedulerInvoiceJobController.deleteScheduledJob";
import reScheduleJob from "@salesforce/apex/LWCSchedulerInvoiceJobController.reScheduleJob";

export default class LwcInvoiceScheduler extends LightningElement {
  cronJobName = "Generate Invoice Job";
  @track currentCronAsTime;
  currentCronAsString;
  loading;
  @track jobDetail;

  connectedCallback() {
    this.loading = true;
    this.getScheduledCron();
  }

  /**
   * On component load - we want to check to see if the job is currently scheduled. If it is
   * scheduled - we can modify the state appropriatley.
   */

  getScheduledCron() {
    getCurrentlyScheduledCron({ cronJobName: this.cronJobName })
      .then((result) => {
        this.jobDetail = result;
        this.stopLoading(500);
      })
      .catch((error) => {
        this.stopLoading(500);
      });
  }

  scheduleApexJob() {
    this.loading = true;
    scheduleJob({
      cronString: this.currentCronAsString,
      cronJobName: this.cronJobName
    })
      .then((data) => {
        console.log(data);
        if (data) {
          this.getScheduledCron();
        } else {
          this.stopLoading(500);
          console.log("Unable to Schedule Job");
        }
      })
      .catch((error) => {
        this.stopLoading(500);
        console.log(error.message);
      });
  }

  reScheduleApexJob() {
    this.loading = true;
    reScheduleJob({
      cronString: this.currentCronAsString,
      cronJobName: this.cronJobName
    })
      .then((data) => {
        console.log(data);
        if (data) {
          this.getScheduledCron();
        } else {
          this.stopLoading(500);
          console.log("Unable to Schedule Job");
        }
      })
      .catch((error) => {
        this.stopLoading(500);
        console.log(error.message);
      });
  }

  deleteJob() {
    this.loading = true;
    deleteScheduledJob({ cronJobName: this.cronJobName })
      .then((data) => {
        console.log(data);
        if (data) {
          this.jobDetail = "";
          this.stopLoading(500);
          console.log("Job Deleted");
        } else {
          this.stopLoading(100);
          console.log("we were unable to delete this job");
        }
      })
      .catch((error) => {
        this.stopLoading(100);
        console.log(error.message);
      });
  }

  get disableButton() {
    return !this.currentCronAsString;
  }

  handleTimeChange(event) {
    let time = event.target.value;
    let [hour, minute, seconds] = time.split(":");
    this.currentCronAsString = `0 ${minute} ${hour} ? * * *`;
  }
  /**
   * The stopLoading utility is used to control a consistant state experience for the user - it ensures that
   * we don't have a flickering spinner effect when the state is in flux.
   * @param {timeoutValue} timeoutValue
   */

  stopLoading(timeoutValue) {
    setTimeout(() => {
      this.loading = false;
    }, timeoutValue);
  }
}