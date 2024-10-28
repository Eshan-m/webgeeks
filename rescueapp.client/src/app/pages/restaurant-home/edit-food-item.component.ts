import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-edit-food-item',
  templateUrl: './edit-food-item.component.html',
  styleUrls: ['./edit-food-item.component.scss']
})
export class EditFoodItemComponent implements OnInit {
  foodItem = { name: '', quantity: 0, expiry: '', condition: '' };

  constructor(private route: ActivatedRoute) {}

  ngOnInit(): void {
    // Fetch food item by ID (API call can be added here)
    const foodName = this.route.snapshot.paramMap.get('name') || ''; // Provide a fallback empty string if null
    console.log('Editing item:', foodName);

    // Mock data for now
    this.foodItem = { name: foodName, quantity: 10, expiry: '2024-10-20', condition: 'fresh' };
  }

  onSave() {
    // Logic to save changes (API call can be added here)
    console.log('Food item saved:', this.foodItem);
  }
}
