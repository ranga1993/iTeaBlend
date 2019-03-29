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
export class ItemService {

  //Defining Constructor Variables
  constructor(private http: Http) { }

  //Calling the getItemDetails method in backend
  getItemDetails(){
    // console.log(this.http.get(urls.oe_url).map(res => res.json()));
    return this.http.get(urls.item_url)
      .map(res => res.json());
  }

  //Calling the addItem method in backend
  addItem(newItem){
    let headers = new Headers();
    headers.append('Content-Type', 'application/json');
    return this.http.post(urls.item_url, newItem, { headers: headers})
      .map(res => res.json());
  } 

  //Calling the updateItem method in backend
  updateItem(item_Id, newItem){
    let headers = new Headers();
    headers.append('Content-Type', 'application/json');
    return this.http.put(urls.item_url + '?Id=' + item_Id, newItem, { headers: headers})
      .map(res => res.json());
  }

  //Calling the deleteItem method in backend
  deleteItem(Id){
    return this.http.delete(urls.item_url + '?Id=' + Id)
      .map(res => res.json());
  }
}
