import { Routes } from '@angular/router';
import { AppDashboardComponent } from './dashboard/dashboard.component';
import { RestaurantHomeComponent } from './restaurant-home/restaurant-home.component';
import { AddFoodItemComponent } from './restaurant-home/add-food-item.component';
import { EditFoodItemComponent } from './restaurant-home/edit-food-item.component';

export const PagesRoutes: Routes = [
  {
    path: '',
    component: AppDashboardComponent,
    data: {
      title: 'Starter Page',
    },
  },
  {
    path: 'restaurant-home',
    component: RestaurantHomeComponent,
    data: {
      title: 'Restaurant Home',
    },
  },
  {
    path: 'add-food-item',
    component: AddFoodItemComponent,
    data: {
      title: 'Add Food Item',
    },
  },
  {
    path: 'edit-food-item/:name',
    component: EditFoodItemComponent,
    data: {
      title: 'Edit Food Item',
    },
  }
];
