import { NgModule } from '@angular/core';
import { HttpModule } from '@angular/http';
import { FormsModule } from '@angular/forms';
import { Routes, RouterModule } from '@angular/router';

import { LoginComponent } from './login/login.component';
import { ElevationComponent } from './elevation/elevation.component';
import { ItemComponent } from './item/item.component';
import { BrokerLocationComponent } from './broker-location/broker-location.component';

const routes: Routes = [
  {path: 'item', component: ItemComponent},
  {path: 'brokerLocation', component: BrokerLocationComponent},
  {path: 'elevation', component: ElevationComponent},
  {path: 'login', component: LoginComponent},
  {path: '', redirectTo: '/login', pathMatch: 'full'}
];

@NgModule({
  imports: [
    HttpModule,
    FormsModule,
    RouterModule.forRoot(routes)
  ],
  exports: [
    RouterModule
  ]
})
export class AppRoutingModule { }
