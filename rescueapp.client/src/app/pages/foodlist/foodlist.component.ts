import { Component, OnInit } from '@angular/core';
import { ServiceService } from './../../../app/service.service';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { Modal } from 'bootstrap';
import { FormsModule } from '@angular/forms';
import Swal from 'sweetalert2';
import { RouterModule } from '@angular/router';
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
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './foodlist.component.html',
  styleUrls: ['./foodlist.component.scss'],

})
export class FoodlistComponent implements OnInit {

  foodItems: any = [];
  selectedFoodId: number | null = null;
  qty: number = 0;
  pickupQuantity: number = 0;
  private modalInstance: Modal | null = null; // Define a property for the modal instance
  isModalOpen: boolean = false;  

  constructor(private router: Router, private service: ServiceService) { }

  ngOnInit(): void {
    this.service.getFoodItems().subscribe(data => {
      this.foodItems = data;
      console.log(this.foodItems);
    });
  }

  openPickupModal(id: number,qty: number) {
    this.selectedFoodId = id;
    this.qty = qty;
    this.isModalOpen = true;  // Open the modal
  }

  confirmPickup() {
    console.log('Record ID:', this.selectedFoodId);
    console.log('Pickup Quantity:', this.pickupQuantity);
    localStorage.getItem("Username");

    if (this.qty == 0) {
      Swal.fire('Enter a valid Quantity', 'Quantity Exceeded', 'error');
    } else {

      if (this.qty > this.pickupQuantity) {

        this.service.Orderfood(this.selectedFoodId, localStorage.getItem("Username"), this.pickupQuantity).subscribe((res) => {
          console.log(res);
          Swal.fire('Successful!', 'Food item added successfully!', 'success');
          window.location.reload(); // Redirect to food list page
        },
          (error) => {
            Swal.fire('Error Occurred', 'Failed to add food item', 'error');
            console.error('Error:', error);
          }
        );
      } else {
        Swal.fire('Quantity Exceeded', 'Quantity Exceeded', 'error');
      }
    }

    // Perform actions like sending the data to the backend or updating state
    this.closeModal();  // Close the modal after confirming
  }

  closeModal() {
    this.isModalOpen = false;  // Close the modal
  }
}
