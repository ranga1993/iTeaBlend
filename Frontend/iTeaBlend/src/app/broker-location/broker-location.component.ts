import { Component, OnInit } from '@angular/core';
import { BrokerLocation } from '../models/brokerLocation';
import { BrokerLocationService } from '../services/broker-location.service';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-broker-location',
  templateUrl: './broker-location.component.html',
  styleUrls: ['./broker-location.component.css'],

  //Data Service Providers
  providers: [BrokerLocationService]
})
export class BrokerLocationComponent implements OnInit {

  //Empty list to store Broker Location Details
  brokerLocationList: BrokerLocation[] = [];

  //Empty Arrays to store Broker Location Details
  addBrokerLocationArray = [];
  editBrokerLocationArray = [];

  //Defining selectedElevation variable
  selectedBrokerLocation: BrokerLocation;

  //Defining toggleForm variable
  toggleForm: boolean = false;

  //Defining Constructor variables
  constructor(private dataService: BrokerLocationService, private router: Router) { }

  //Get Broker Locations
  getBrokerLocations(){
    this.dataService.getBrokerLocationDetails()
    .subscribe( brokerLocations => {
      this.brokerLocationList.push(brokerLocations);
      this.addBrokerLocationArray.push(this.brokerLocationList[0]['response']['getBrokerLocations']['getBrokerLocations']);
      // console.log(this.addBrokerLocationArray);
    });
  }

  //Insert a Broker Location
  addBrokerLocation(form){
    let newBrokerLocation = {
      request: {
        Broker: form.value.Broker,
        Broker_Location_Code: form.value.Broker_Location_Code,
        Location: form.value.Location
      }
    }
    // console.log(newBrokerLocation);
    this.dataService.addBrokerLocation(newBrokerLocation)
      .subscribe( brokerLocations => {
        window.location.reload();
        // this.getItems();
      })
  }

  //Delete a Broker Location
  deleteBrokerLocation(Id){
    this.dataService.deleteBrokerLocation(Id)
      .subscribe( data => {
        console.log(data);
        if(data.affectedRows == 1){
          for(var i=0; i < this.addBrokerLocationArray.length; i++){
            if(Id == this.addBrokerLocationArray[i].Id){
              this.addBrokerLocationArray.splice(i, 1);
            }
          }
        }
        window.location.reload();
      })
  }

  //Enabling Edit Form when click on Edit button
  showEditForm(bLocation){
    this.selectedBrokerLocation = bLocation;
    this.toggleForm = !this.toggleForm;
  }

  //Update a Broker Location
  editBrokerLocation(form){
    let newBrokerLocation = {
      request: {
        BrokerLocationsSet: {
          updateBrokerLocation: [{
            Id :this.selectedBrokerLocation.Id,
            Broker: form.value.Broker,
            Broker_Location_Code: form.value.Broker_Location_Code,
            Location: form.value.Location
          }]
        }
      }
    }
    this.editBrokerLocationArray.push(newBrokerLocation);
    console.log(this.editBrokerLocationArray);

    // console.log(this.editBrokerLocationArray[0]['request']['BrokerLocationSet']['updateBrokerLocation'][0]);
    let broker_Location_Id = this.editBrokerLocationArray[0]['request']['BrokerLocationsSet']['updateBrokerLocation'][0].Id;
    

    this.dataService.updateBrokerLocation(broker_Location_Id, newBrokerLocation)
      .subscribe( result => {
        console.log('Original item to be updated with old values: ' + result);
        this.ngOnInit();
      });
      this.toggleForm = !this.toggleForm;
      window.location.reload();
  }

  ngOnInit() {
    this.getBrokerLocations();
    // this.dataService.getItemDetails()
    // .subscribe( elevations => {
    //   this.itemList.push(elevations);
    //   this.addItemArray.push(this.itemList[0]['response']['getItems']['getItems']);
    //   console.log(this.addItemArray);
    // });
  }


}
