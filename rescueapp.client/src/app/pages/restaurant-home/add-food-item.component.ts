import { Component } from '@angular/core';
import { ServiceService } from './../../../app/service.service';
import Swal from 'sweetalert2';
import { Router } from '@angular/router';

@Component({
  selector: 'app-add-food-item',
  templateUrl: './add-food-item.component.html',
  styleUrls: ['./add-food-item.component.scss']
})





export class AddFoodItemComponent {
  foodItem = { name: '', quantity: 0, expiry: '', condition: '' };

  constructor(private router: Router,private service: ServiceService) { }


  onSubmit() {
    // Logic to add new food item (API call can be added here)
    console.log('New food item added:', this.foodItem);
  }



  addFoodItem() {
    // Validate mandatory fields

    if (this.foodItem.quantity == 0) {
      Swal.fire('Enter a valid Quantity', 'Quantity Exceeded', 'error');
    } else {


      if (
        !this.foodItem.name ||
        this.foodItem.quantity <= 0 ||
        !this.foodItem.expiry
      ) {
        Swal.fire('', 'Please fill all mandatory fields!', 'warning');
      } else {
        // Prepare data and send to API
        const val = {
          name: this.foodItem.name,
          quantity: this.foodItem.quantity,
          expiry: this.foodItem.expiry,
          condition: this.foodItem.condition,
          user: localStorage.getItem("Username")
        };

        this.service.addFoodItem(val).subscribe((res) => {
          console.log(res);
          Swal.fire('Successful!', 'Food item added successfully!', 'success');
          this.router.navigate(['/resturant-home']); // Redirect to food list page
        },
          (error) => {
            Swal.fire('Error Occurred', 'Failed to add food item', 'error');
            console.error('Error:', error);
          }
        );
      }
    }
  }







}
