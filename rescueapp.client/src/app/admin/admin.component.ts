import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-restaurant-management',
  templateUrl: './restaurant-management.component.html',
  styleUrls: ['./restaurant-management.component.scss']
})
export class RestaurantManagementComponent implements OnInit {
  restaurants = [
    { name: 'Palm Restaurant', location: '123 Main St', owner: 'John Doe' },
    { name: 'ABC Restaurant', location: '456 Side Ave', owner: 'Jane Smith' }
  ];

  constructor() { }

  ngOnInit(): void { }

  deleteRestaurant(index: number): void {
    this.restaurants.splice(index, 1);
  }
}

