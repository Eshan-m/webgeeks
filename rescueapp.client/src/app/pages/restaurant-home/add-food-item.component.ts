import { Component } from '@angular/core';

@Component({
  selector: 'app-add-food-item',
  templateUrl: './add-food-item.component.html',
  styleUrls: ['./add-food-item.component.scss']
})
export class AddFoodItemComponent {
  foodItem = { name: '', quantity: 0, expiry: '', condition: '' };

  onSubmit() {
    // Logic to add new food item (API call can be added here)
    console.log('New food item added:', this.foodItem);
  }
}
