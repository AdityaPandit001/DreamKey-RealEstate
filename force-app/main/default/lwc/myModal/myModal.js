import { api,wire } from 'lwc';
import LightningModal from 'lightning/modal';
import OpenProperties from '@salesforce/apex/PropertyClass.fetchOpenProperties';

export default class MyModal extends LightningModal {
    @api content;

    handleOkay() {
        this.close('okay');
    }

     columns = [
            { label: 'Property', fieldName: 'Property_Name__c' },
            { label: 'City', fieldName: 'Property_City__c' },
            { label: 'State', fieldName: 'Property_State__c' },
            { label: 'Status', fieldName: 'Status__c' },
            { label: 'Sale Price', fieldName: 'Listing_Price__c', type: 'currency' },
        ];
    
        properties;
        error;
    
        @wire(OpenProperties)
        wiredProperties({ data, error }) {
            if (data) {
                this.properties = data;
                this.error = undefined;
            } else if (error) {
                this.properties = undefined;
                this.error = error;
                console.error('Error fetching properties:', error);
            }
        }
}