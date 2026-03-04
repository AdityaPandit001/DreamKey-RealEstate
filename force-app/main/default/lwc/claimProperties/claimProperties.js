import { LightningElement, api } from 'lwc';
import MyModal from 'c/claimPropertyModal';
import claimProp from '@salesforce/apex/PropertyClass.claimSingleProperties';

import {ShowToastEvent} from 'lightning/platformShowToastEvent';



export default class ClaimProperties extends LightningElement{
    async handleClick() {
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
    }

    @api recordId; 


   
   
        async handleSingleClaim() {
            console.log('recordId: ' + this.recordId);
        console.log('Claim button clicked');
                    try {
                        this.contacts = await claimProp({ searchKey: this.recordId });
                        this.error = undefined;
                        console.log('success');
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Records Claimed Successfully!!',
                                variant: 'success'
                            })
                        );
                        window.location.reload();
                    } catch (error) {
                        this.error = error;
                        this.contacts = undefined;
                        console.log('Failed'+this.error);

                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Failed',
                                message: 'ERROR OCCORED! Contact Your Admin ',
                                variant: 'error'
                            })
                        );
                    }
                   
                    
                }

}