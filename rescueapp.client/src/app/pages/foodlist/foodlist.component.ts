// foodlist.component.ts
import { Component, OnInit } from '@angular/core';
import { ServiceService } from './../../../app/service.service';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { Modal } from 'bootstrap';
import { FormsModule } from '@angular/forms';

export interface FoodItem {
  id: number;
  food_name: string;
  quantity: number;
  expiration_date: Date;
  restaurant_id: number;
}

@Component({
  selector: 'app-foodlist',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './foodlist.component.html',
  styleUrls: ['./foodlist.component.scss']
})
export class FoodlistComponent implements OnInit {
  foodItems: FoodItem[] = []; // Specify array type
  filteredFoodItems: FoodItem[] = []; // Specify array type
  selectedFoodId: number | null = null;
  pickupQuantity: number | null = null;
  private modalInstance: Modal | null = null;
  isModalOpen: boolean = false;
  searchQuery: string = ''; // Variable to store search input

  constructor(private router: Router, private service: ServiceService) { }

  ngOnInit(): void {
    this.service.getFoodItems().subscribe((data: FoodItem[]) => {
      this.foodItems = data;
      this.filteredFoodItems = data; // Initialize filtered items
      console.log(this.foodItems);
    });
  }

  openPickupModal(id: number) {
    this.selectedFoodId = id;
    this.isModalOpen = true;
  }

  confirmPickup() {
    console.log('Record ID:', this.selectedFoodId);
    console.log('Pickup Quantity:', this.pickupQuantity);
    this.closeModal();
  }

  closeModal() {
    this.isModalOpen = false;
  }

  // Method to filter food items based on search input
  onSearch(): void {
    this.filteredFoodItems = this.foodItems.filter(item =>
      item.food_name.toLowerCase().includes(this.searchQuery.toLowerCase())
    );
  }
}
