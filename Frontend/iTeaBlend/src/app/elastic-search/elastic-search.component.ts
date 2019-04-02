import { Component, OnInit } from '@angular/core';
import { Item } from '../models/item';
import { ElasticSearchService } from '../services/elastic-search.service';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-elastic-search',
  templateUrl: './elastic-search.component.html',
  styleUrls: ['./elastic-search.component.css'],

  //Data Service Providers
  providers: [ElasticSearchService]
})
export class ElasticSearchComponent implements OnInit {

  //Empty list to store Item Details
  itemList: Item[] = [];

  searchString: string;

  //Empty Arrays to store Item Details
  addItemArray = [];
  editItemArray = [];

  resArray = [];
  searchArray = [];

  //Defining Constructor variables
  constructor(private dataService: ElasticSearchService, private router: Router) { }

  //Get Items
  getItems(){
    this.dataService.getItemDetails()
    .subscribe( elevations => {
      this.itemList.push(elevations);
      this.addItemArray.push(this.itemList[0]['response']['getItems']['getItems']);
    });
  }

  ngOnInit() {
    this.getItems();
  }

  Search(){
    if(this.searchString != " "){
      this.itemList.filter(res=>{
        this.resArray.push(res);
        this.resArray[0]['response']['getItems']['getItems'].forEach(element => {
          if((element.Description.toLocaleLowerCase().match(this.searchString.toLocaleLowerCase()) != null) || (element.Id.toLocaleLowerCase().match(this.searchString.toLocaleLowerCase()) != null) || (element.Item_Code.toLocaleLowerCase().match(this.searchString.toLocaleLowerCase()) != null)){ 
            this.searchArray.push(element);
          }
        });
        console.log(this.searchArray);
        this.addItemArray[0] = this.searchArray;
      });
      this.searchArray = [];
    }
    else if(this.searchString == " "){
      this.ngOnInit();
    }
  }

}
