import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BrokerLocationComponent } from './broker-location.component';

describe('BrokerLocationComponent', () => {
  let component: BrokerLocationComponent;
  let fixture: ComponentFixture<BrokerLocationComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BrokerLocationComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BrokerLocationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
