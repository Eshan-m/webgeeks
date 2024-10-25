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
  styleUrls: ['./foodlist.component.scss']  // Corrected "styleUrls" with an 's'
})
export class FoodlistComponent implements OnInit {

  foodItems: any = [];
  selectedFoodId: number | null = null;
  pickupQuantity: number | null = null;
  private modalInstance: Modal | null = null; // Define a property for the modal instance
  isModalOpen: boolean = false;  

  constructor(private router: Router, private service: ServiceService) { }

  ngOnInit(): void {
    this.service.getFoodItems().subscribe(data => {
      this.foodItems = data;
      console.log(this.foodItems);
    });
  }

  openPickupModal(id: number) {
    this.selectedFoodId = id;
    this.isModalOpen = true;  // Open the modal
  }

  confirmPickup() {
    console.log('Record ID:', this.selectedFoodId);
    console.log('Pickup Quantity:', this.pickupQuantity);
    // Perform actions like sending the data to the backend or updating state
    this.closeModal();  // Close the modal after confirming
  }

  closeModal() {
    this.isModalOpen = false;  // Close the modal
  }
}
