import { Injectable } from '@angular/core';
import { Http, Response, Headers } from '@angular/http';
import 'rxjs/add/operator/map';
import 'rxjs/Rx';
import 'rxjs/operators';
import 'rxjs/add/operator/catch';
import { urls } from '../base_url/base_url';
import { Observable } from 'rxjs';
import { Item } from '../models/item';

@Injectable({
  providedIn: 'root'
})
export class BrokerLocationService {

  //Defining Constructor Variables
  constructor(private http: Http) { }

  //Calling the getBrokerLocationDetails method in backend
  getBrokerLocationDetails(){
    return this.http.get(urls.bLocation_url)
      .map(res => res.json());
  }

  //Calling the addBrokerLocation method in backend
  addBrokerLocation(newBrokerLocation){
    let headers = new Headers();
    headers.append('Content-Type', 'application/json');
    return this.http.post(urls.bLocation_url, newBrokerLocation, { headers: headers})
      .map(res => res.json());
  } 

  //Calling the updateBrokerLocation method in backend
  updateBrokerLocation(broker_Location_Id, newBrokerLocation){
    let headers = new Headers();
    headers.append('Content-Type', 'application/json');
    return this.http.put(urls.bLocation_url + '?Id=' + broker_Location_Id, newBrokerLocation, { headers: headers})
      .map(res => res.json());
  }

  //Calling the deleteBrokerLocation method in backend
  deleteBrokerLocation(Id){
    return this.http.delete(urls.bLocation_url + '?Id=' + Id)
      .map(res => res.json());
  }
}
