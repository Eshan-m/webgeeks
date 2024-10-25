import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FoodlistComponent } from './foodlist.component';

describe('FoodlistComponent', () => {
  let component: FoodlistComponent;
  let fixture: ComponentFixture<FoodlistComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [FoodlistComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(FoodlistComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
