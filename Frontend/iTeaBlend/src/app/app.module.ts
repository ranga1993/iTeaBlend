import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpModule } from '@angular/http';
import { FormsModule } from '@angular/forms';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { LoginComponent } from './login/login.component';
import { ElevationComponent } from './elevation/elevation.component';
import { ItemComponent } from './item/item.component';
import { BrokerLocationComponent } from './broker-location/broker-location.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    ElevationComponent,
    ItemComponent,
    BrokerLocationComponent
  ],
  imports: [
    BrowserModule,
    HttpModule,
    FormsModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
