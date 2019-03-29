import { Component, OnInit } from '@angular/core';
import { Elevation } from '../models/elevation';
import { ElevationService } from '../services/elevation.service';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-elevation',
  templateUrl: './elevation.component.html',
  styleUrls: ['./elevation.component.css'],

  //Data Service Providers
  providers: [ElevationService]
})
export class ElevationComponent implements OnInit {
  //Empty list to store Elevation Details
  elevationList: Elevation[] = [];

  abc = [];
  pqr = [];

  //Defining selectedElevation variable
  selectedElevation: Elevation;

  //Defining toggleForm variable
  toggleForm: boolean = false;

  //Defining Constructor variables
  constructor(private dataService: ElevationService, private router: Router) { }

  //Get Elevations
  getElevations(){
    // this.dataService.getElevationDetails()
    //   .subscribe( elevations => {
    //     this.elevationList  = elevations;
    //   })
    // this.dataService.getElevationDetails()
    // .subscribe( elevations => {
    //   this.elevationList  = elevations;
    // });
  }

  //Enabling Edit Form when click on Edit button
  showEditForm(elevation){
    this.selectedElevation = elevation;
    this.toggleForm = !this.toggleForm;
  }

  ngOnInit() {
    this.dataService.getElevationDetails()
    .subscribe( elevations => {
      // console.log(elevations);
      this.elevationList.push(elevations);
      this.abc.push(this.elevationList[0]['response']['getElevations']['getElevations']);
      // this.abc.push(this.elevationList);
      // this.pqr.push(this.abc[0]);
      // this.elevationList = elevations;
      // this.abc[0]['response']['getElevations']['getElevations'];
      // console.log(this.abc[0]['response']['getElevations']['getElevations'][0]['Id']);
      console.log(this.abc);
    });
  }

}
