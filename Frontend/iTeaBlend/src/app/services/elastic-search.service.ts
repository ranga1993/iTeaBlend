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
export class ElasticSearchService {

  //Defining Constructor Variables
  constructor(private http: Http) { }

  //Calling the getItemDetails method in backend
  getItemDetails(){
    // console.log(this.http.get(urls.oe_url).map(res => res.json()));
    return this.http.get(urls.item_url)
      .map(res => res.json());
  }
}
