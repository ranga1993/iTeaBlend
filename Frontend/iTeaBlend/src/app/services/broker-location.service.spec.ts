import { TestBed } from '@angular/core/testing';

import { BrokerLocationService } from './broker-location.service';

describe('BrokerLocationService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: BrokerLocationService = TestBed.get(BrokerLocationService);
    expect(service).toBeTruthy();
  });
});
