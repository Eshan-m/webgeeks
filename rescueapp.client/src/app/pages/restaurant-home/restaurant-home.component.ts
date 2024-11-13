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
  totalItems = 0; // Will display the total number of food items


  restaurantUsername: string = 'exa'; 

  constructor(private router: Router, private service: ServiceService) { }

  ngOnInit(): void {
    // Fetch food items (API call can be added here)
  
      this.loadFoodItems();
    
  
  }

  onDelete(item: { name: string; quantity: number; expiry: string; status: string; id: number }): void {
    console.log(item.id);
    this.service.Deletefooditem(item.id).subscribe(
      (items) => {
        window.location.reload();
      },
      (error) => {
        console.error('Error fetching food items', error);
      }
    );
  }

  loadFoodItems(): void {
  
    this.service.GetfooditemsRes(localStorage.getItem("Username")?.toString()).subscribe(
      (items) => {
        this.foodItems = items;
       
        // Update total items count
        console.log(this.totalItems = this.foodItems.length);
      },
      (error) => {
        console.error('Error fetching food items', error);
      }
    );
  }




}
