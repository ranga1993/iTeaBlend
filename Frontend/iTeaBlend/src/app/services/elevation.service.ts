import { Injectable } from '@angular/core';
import { Http, Response, Headers } from '@angular/http';
import 'rxjs/add/operator/map';
import 'rxjs/Rx';
import 'rxjs/operators';
import 'rxjs/add/operator/catch';
import { urls } from '../base_url/base_url';
import { Observable } from 'rxjs';
import { Elevation } from '../models/elevation';

@Injectable({
  providedIn: 'root'
})
export class ElevationService {

  //Defining Constructor Variables
  constructor(private http: Http) { }

  //Calling the get_elevations method in backend
  getElevationDetails(){
    // console.log(this.http.get(urls.oe_url).map(res => res.json()));
    return this.http.get(urls.oe_url)
      .map(res => res.json());
  }
}
