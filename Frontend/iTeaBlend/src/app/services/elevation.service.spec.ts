import { TestBed } from '@angular/core/testing';

import { ElevationService } from './elevation.service';

describe('ElevationService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: ElevationService = TestBed.get(ElevationService);
    expect(service).toBeTruthy();
  });
});
