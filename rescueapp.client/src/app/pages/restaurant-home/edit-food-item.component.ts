import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { ServiceService } from './../../../app/service.service';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-edit-food-item',
  templateUrl: './edit-food-item.component.html',
  styleUrls: ['./edit-food-item.component.scss']
})
export class EditFoodItemComponent implements OnInit {
  foodItems: any = [];
  foodId: number=0;
  constructor(private route: ActivatedRoute, private service: ServiceService) {}

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('name');
    this.foodId = id ? +id : 0; // Convert `id` to a number

    // Log or use the `foodId` as needed
    console.log("Food ID:", this.foodId);

    // Ensure foodId is not null before calling loadFoodItem
    if (this.foodId) {
      this.loadFoodItem(this.foodId);
    }
    
  }

  loadFoodItem(id: number): void {
    this.service.getFoodItemById(id).subscribe(
      (data: any) => {
        // Handle the case where the response is an array
        if (Array.isArray(data) && data.length > 0) {
          this.foodItems = data[0]; // Use the first element if it's an array
        } else {
          this.foodItems = data; // Directly assign the response if it's a single object
        }

    

        console.log(this.foodItems); // Debugging: log the data
      },
      (error) => {
        console.error('Failed to load food item', error);
      }
    );
  }

  onSave() {
    this.service.updateFoodItem(this.foodId, this.foodItems).subscribe(
      response => {
        console.log('Food item updated successfully', response);
        // Redirect or show a success message
        Swal.fire('Successful!', 'Food item updated successfully!', 'success');
      },
      error => {
        console.error('Error updating food item', error);
      }
    );
  }

}
