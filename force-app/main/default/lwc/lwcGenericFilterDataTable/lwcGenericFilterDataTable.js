import { LightningElement ,api,track} from "lwc";

export default class LwcGenericFilterDataTable extends LightningElement {
  @api flexipageRegionWidth;
  @track value = 'inProgress';

  get options() {
      return [
          { label: 'New', value: 'new' },
          { label: 'In Progress', value: 'inProgress' },
          { label: 'Finished', value: 'finished' },
      ];
  }

  handleChange(event) {
      this.value = event.detail.value;
  }
}
