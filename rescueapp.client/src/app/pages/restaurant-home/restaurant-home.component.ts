import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-restaurant-home',
  templateUrl: './restaurant-home.component.html',
  styleUrls: ['./restaurant-home.component.scss']
})
export class RestaurantHomeComponent implements OnInit {
  foodItems: { name: string; quantity: number; expiry: string; status: string }[] = [];
  totalItems = 0; // Will display the total number of food items

  constructor() {}

  ngOnInit(): void {
    // Fetch food items (API call can be added here)
    this.foodItems = [
      { name: 'Pizza', quantity: 5, expiry: '2024-10-20', status: 'Available' },
      { name: 'Bread', quantity: 10, expiry: '2024-10-18', status: 'Expired' }
    ];
    this.totalItems = this.foodItems.length;
  }

  onDelete(item: { name: string; quantity: number; expiry: string; status: string }): void {
    // Logic to delete item (API call can be added here)
    console.log('Deleting item:', item);
  }
}
