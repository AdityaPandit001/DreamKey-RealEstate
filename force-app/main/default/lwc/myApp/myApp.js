import { LightningElement, api,track,wire} from 'lwc';
import pendingProperties from '@salesforce/apex/SalesOfficeClass.fetchClosePendingProperties';
import approveProperties from '@salesforce/apex/SalesOfficeClass.approveProperties';
import rejectProperties from '@salesforce/apex/SalesOfficeClass.rejectProperties';
import OfficeName from '@salesforce/apex/SalesOfficeClass.getOfficeName';
import OfficeYearToDateSales from '@salesforce/apex/SalesOfficeClass.getYearToDateSales';



import { updateRecord } from "lightning/uiRecordApi";
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
 



export default class MyApp extends LightningElement {

  @api recordId;
  connectedCallback(){
      console.log(this.recordId);
  
  }

     columns = [
                 {  label: 'Property Id', fieldName: 'Id' },
                    { label: 'Property', fieldName: 'Property_Name__c' },
                    { label: 'Agent Id', fieldName: 'Agent__c' },
                    { label: 'Listing Price', fieldName: 'Listing_Price__c' },
                    { label: 'Sales Price', fieldName: 'Sales_Price__c' },
                    { label: 'Agent commission', fieldName: 'Agent_Commission_Percentage__c',editable:true},
                ];


                @wire(OfficeName, { officeId: '$recordId' })officeName;

                @wire(OfficeYearToDateSales, { officeId: '$recordId' })OfficeYearToDateSales;
                












                draftValues=[];
               //edit value save
    handleSave(event) {
        // Convert datatable draft values into record objects
        this.draftValues = event.detail.draftValues;
        console.log('--- check draft value--',this.draftValues);
        const inputsItems = this.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
    
        // Clear all datatable draft values
        //this.draftValues = [];
    
        try {
          // Update all records in parallel thanks to the UI API
          const promises = inputsItems.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(res => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Records Updated Successfully!!',
                    variant: 'success'
                })
            );
            this.draftValues = [];
            window.location.reload();
            return refreshApex(this.properties);
            
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'An Error Occured!!'+error,
                    variant: 'error'
                })
            );
        }).finally(() => {
            this.draftValues = [];
        });
    
        }catch(error){
            console.log('--- error--',error);
        }
        }
    
            


            
                properties;
                error;
            
                @wire(pendingProperties, { officeId: '$recordId' })
                wiredProperties({ data, error }) {
                    if (data) {
                        console.log('Fetched Data:', data);
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
 
 
               searchKey =this.selectedPropertyIds;
                      contacts;
                      error;
                     
                      async handleApprove() {
                          try {
                              this.contacts = await approveProperties({ searchKey: this.searchKey });
                              this.error = undefined;
                              console.log('success');
                              console.log('ids'+this.searchKey);

                              this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Approved',
                                    message: 'Approved successfully!!',
                                    variant: 'success'
                                })
                            );
                             
                              window.location.reload();
 
                          } catch (error) {
                              this.error = error;
                              this.contacts = undefined;
                              console.log('Failed'+ JSON.stringify(this.error))
                              this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Failed',
                                    message: 'failed to approve properties!!',
                                    variant: 'error'
                                })
                            );
                          }
                          
                         
 
                         
                          
                      }
 
                      async handleReject() {
                         
                         try {
                             this.contacts = await rejectProperties({ searchKey: this.searchKey });
                             this.error = undefined;
                             console.log('success');
                             console.log('ids'+this.searchKey);
                             this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'WithDrawn',
                                    message: 'Properties succesfully WithDrawn Successfully!!',
                                    variant: 'success'
                                })
                            );
                             window.location.reload();
                         } catch (error) {
                             this.error = error;
                             this.contacts = undefined;
                             console.log('Failed'+ JSON.stringify(this.error))

                             this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Faied',
                                    message: 'Properties Failed to WithDrawn Successfully!!',
                                    variant: 'success'
                                })
                            );
                         }
                         
                        
                     }
 
                     handleClose(){
                    console.log('prop='+this.properties);
                    console.log('recordId='+this.recordId);
                    window.location.reload();
                    
                    
                         
                     }
 
 

}