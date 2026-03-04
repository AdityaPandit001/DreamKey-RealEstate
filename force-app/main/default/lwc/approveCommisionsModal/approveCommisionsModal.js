import { api,wire , track} from 'lwc';
import LightningModal from 'lightning/modal';




import pendingProperties from '@salesforce/apex/SalesOfficeClass.fetchClosePendingProperties';
import approveProperties from '@salesforce/apex/SalesOfficeClass.approveProperties';
import rejectProperties from '@salesforce/apex/SalesOfficeClass.rejectProperties';



export default class ApproveCommisionsModal extends LightningModal {
      
     
   

       
      handleOkay() {
        console.log('id='+this.recId);
        this.dispatchEvent(new CustomEvent('closemodal'));

               this.close('okay');
              
           }
       
            columns = [
                {  label: 'Property Id', fieldName: 'Id' },
                   { label: 'Property', fieldName: 'Property_Name__c' },
                   { label: 'sales Office', fieldName: 'sales_office__c' },
                   { label: 'Listing Price', fieldName: 'Listing_Price__c' },
                   { label: 'Sales Price', fieldName: 'Sales_Price__c' },
                   { label: 'Agent commission', fieldName: 'Agent_Commission_Percentage__c'},
               ];
           
             @track  properties;
               error;
           
               @wire(pendingProperties)
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
                            
                             window.location.reload();

                         } catch (error) {
                             this.error = error;
                             this.contacts = undefined;
                             console.log('Failed'+ JSON.stringify(this.error))
                         }
                         
                         this.close('okay');

                        
                         
                     }

                     async handleReject() {
                        
                        try {
                            this.contacts = await rejectProperties({ searchKey: this.searchKey });
                            this.error = undefined;
                            console.log('success');
                            console.log('ids'+this.searchKey);
                            window.location.reload();
                        } catch (error) {
                            this.error = error;
                            this.contacts = undefined;
                            console.log('Failed'+ JSON.stringify(this.error))
                        }
                        
                        this.close('okay');
                        
                    }

                    handleClose(){
                   console.log(JSON.stringify(this.properties));
                    this.close('okay');

                   
                        
                    }


                    
                  
}