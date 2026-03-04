import { LightningElement ,api,wire,track } from 'lwc';
import MyModal from 'c/approveCommisionsModal';
import pendingProperties from '@salesforce/apex/SalesOfficeClass.fetchClosePendingProperties';


export default class ApproveCommisions extends LightningElement {
    @track properties;
    @api recordId;
    
   
   
    error;


     @wire(pendingProperties,{officeId:'$recordId'})
                   wiredProperties({ data, error }) {
                       if (data) {
                        console.log(data);
                           this.properties = data;
                           this.error = undefined;
                       } else if (error) {
                           this.properties = undefined;
                           this.error = error;
                           console.error('Error fetching properties:', error);
                       }
                   }

      async handleClick() {
        console.log(this.recordId);
     

            const result = await MyModal.open({
                // `label` is not included here in this example.
                // it is set on lightning-modal-header instead
                size: 'large',
                description: 'Accessible description of modal\'s purpose',
                content: 'Passed into content api',
            });
            // if modal closed with X button, promise returns result = 'undefined'
            // if modal closed with OK button, promise returns result = 'okay'
            console.log(result);
           // window.location.reload();
        }
}