import { Component, OnInit } from '@angular/core';
import { ServiceService } from './../../../app/service.service';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { Modal } from 'bootstrap';
import { FormsModule } from '@angular/forms';
import Swal from 'sweetalert2';


export interface FoodItem {
  id: number;
  FoodName: string;
  quantity: number;
  CreatedAt: Date;
}



@Component({
  selector: 'app-orders',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './orders.component.html',
  styleUrl: './orders.component.scss'
})


export class OrdersComponent implements OnInit {

  foodItems: any = [];
  selectedFoodId: number | null = null;
  pickupQuantity: number | null = null;
  private modalInstance: Modal | null = null; // Define a property for the modal instance
  isModalOpen: boolean = false;  



  constructor(private router: Router, private service: ServiceService) { }

  ngOnInit(): void {
    this.service.Getfooditemsordered(localStorage.getItem("Username")).subscribe(data => {
      this.foodItems = data;
      console.log(this.foodItems);
    });
  }
}
