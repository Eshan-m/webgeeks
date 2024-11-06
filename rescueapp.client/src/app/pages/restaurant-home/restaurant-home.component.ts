// restaurant-home.component.ts
import { Component, OnInit } from '@angular/core';
import { ServiceService } from './../../../app/service.service';
import Swal from 'sweetalert2';
import { Router } from '@angular/router';

@Component({
  selector: 'app-restaurant-home',
  templateUrl: './restaurant-home.component.html',
  styleUrls: ['./restaurant-home.component.scss']
})
export class RestaurantHomeComponent implements OnInit {
  foodItems: any = [];
  filteredFoodItems: any = []; // List for filtered food items
  totalItems = 0;
  restaurantUsername: string = 'exa';
  searchQuery: string = ''; // Variable to store search term

  constructor(private router: Router, private service: ServiceService) { }

  ngOnInit(): void {
    this.loadFoodItems();
  }

  onDelete(item: { name: string; quantity: number; expiry: string; status: string }): void {
    console.log('Deleting item:', item);
  }

  loadFoodItems(): void {
    this.service.GetfooditemsRes(localStorage.getItem("Username")?.toString()).subscribe(
      (items) => {
        this.foodItems = items;
        this.filteredFoodItems = items; // Initialize filtered list
        this.totalItems = this.foodItems.length;
      },
      (error) => {
        console.error('Error fetching food items', error);
      }
    );
  }

  // Method to filter food items based on search query
  onSearch(): void {
    this.filteredFoodItems = this.foodItems.filter((item: any) =>
      item.food_name.toLowerCase().includes(this.searchQuery.toLowerCase())
    );
  }
}
