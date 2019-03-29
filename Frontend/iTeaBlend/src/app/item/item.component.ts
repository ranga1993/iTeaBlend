import { Component, OnInit } from '@angular/core';
import { Item } from '../models/item';
import { ItemService } from '../services/item.service';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-item',
  templateUrl: './item.component.html',
  styleUrls: ['./item.component.css'],

  //Data Service Providers
  providers: [ItemService]
})
export class ItemComponent implements OnInit {

  //Empty list to store Item Details
  itemList: Item[] = [];

  //Empty Arrays to store Item Details
  addItemArray = [];
  editItemArray = [];

  //Defining selectedItem variable
  selectedItem: Item;

  //Defining toggleForm variable
  toggleForm: boolean = false;

  //Defining Constructor variables
  constructor(private dataService: ItemService, private router: Router) { }

  //Get Items
  getItems(){
    this.dataService.getItemDetails()
    .subscribe( elevations => {
      this.itemList.push(elevations);
      this.addItemArray.push(this.itemList[0]['response']['getItems']['getItems']);
    });
  }

  //Insert an Item
  addItem(form){
    let newItem = {
      request: {
        Item_Code: form.value.Item_Code,
        Description: form.value.Description
      }
    }
    console.log(newItem);
    this.dataService.addItem(newItem)
      .subscribe( item => {
        window.location.reload();
        // this.getItems();
      })
  }

  //Delete an Item
  deleteItem(Id){
    this.dataService.deleteItem(Id)
      .subscribe( data => {
        console.log(data);
        if(data.affectedRows == 1){
          for(var i=0; i < this.addItemArray.length; i++){
            if(Id == this.addItemArray[i].Id){
              this.addItemArray.splice(i, 1);
            }
          }
        }
        window.location.reload();
      })
  }

  //Enabling Edit Form when click on Edit button
  showEditForm(item){
    this.selectedItem = item;
    this.toggleForm = !this.toggleForm;
  }

  //Update an Item
  editItem(form){
    let newItem = {
      request: {
        ItemSet: {
          updateItem: [{
            Id :this.selectedItem.Id,
            Item_Code: form.value.Item_Code,
            Description: form.value.Description
          }]
        }
      }
    }
    this.editItemArray.push(newItem);

    let item_Id = this.editItemArray[0]['request']['ItemSet']['updateItem'][0].Id;

    this.dataService.updateItem(item_Id, newItem)
      .subscribe( result => {
        console.log('Original item to be updated with old values: ' + result);
        this.ngOnInit();
      });
      this.toggleForm = !this.toggleForm;
      window.location.reload();
  }

  ngOnInit() {
    this.getItems();
    // this.dataService.getItemDetails()
    // .subscribe( elevations => {
    //   this.itemList.push(elevations);
    //   this.addItemArray.push(this.itemList[0]['response']['getItems']['getItems']);
    //   console.log(this.addItemArray);
    // });
  }


}
