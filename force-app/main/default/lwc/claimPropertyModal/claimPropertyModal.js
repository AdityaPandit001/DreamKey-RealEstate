import {
    api,
    track,
    wire
} from 'lwc';
import LightningModal from 'lightning/modal';
import OpenProperties from '@salesforce/apex/PropertyClass.fetchOpenProperties';
import claimProp from '@salesforce/apex/PropertyClass.claimProperties';

import {ShowToastEvent} from 'lightning/platformShowToastEvent';



export default class ClaimPropertyModal extends LightningModal {
    @api content;

    

    handleOkay() {
        window.location.reload();
        this.close('okay');
    }

    columns = [

        {
            label: 'Property Id',
            fieldName: 'Id'
        },
        {
            label: 'Property',
            fieldName: 'Property_Name__c'
        },
        {
            label: 'City',
            fieldName: 'Property_City__c'
        },
        {
            label: 'Listing Price',
            fieldName: 'Listing_Price__c',
            type: 'currency'
        },
       
        {
            label: 'Status',
            fieldName: 'Status__c'
        },
        {
            label: 'Date Added',
            fieldName: 'CreatedDate'
        }
    ];

    @track properties;
    error;

    
    @wire(OpenProperties)
    wiredProperties({
        data,
        error
    }) {
        if (data) {
            this.properties = data;
            this.error = undefined;
        } else if (error) {
            this.properties = undefined;
            this.error = error;
            console.error('Error fetching properties:', error);
        }
    }

    
    

    

    @track selectedPropertyIds = [];
    getSelectedRows(event) {
        const selectedRows = event.detail.selectedRows;

        for (let i = 0; i < selectedRows.length; i++) {
            this.selectedPropertyIds.push(selectedRows[i].Id);
        }
    }
     @track searchKey =this.selectedPropertyIds;
        contacts;
        error;
       
        async handleClaim() {
            try {
                const result = await claimProp({ searchKey: this.searchKey }); // Wait for the Apex call
                this.error = undefined;
                console.log('Success:');
               

                window.location.reload();
        
                // Instead of reloading the page, you can dispatch an event to update data
              //  this.dispatchEvent(new CustomEvent('refresh'));
        
             //   this.close('okay'); // Move this inside try block after success
            } catch (error) {
                this.error = error;
                console.error('Failed:', JSON.stringify(error));
                
            }
        }


        handleClose(){
            window.location.reload();
            this.close('okay');
        }


}