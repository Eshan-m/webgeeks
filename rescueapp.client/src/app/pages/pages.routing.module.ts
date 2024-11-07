import { Routes } from '@angular/router';
import { AppDashboardComponent } from './dashboard/dashboard.component';
import { RestaurantHomeComponent } from './restaurant-home/restaurant-home.component';
import { AddFoodItemComponent } from './restaurant-home/add-food-item.component';
import { EditFoodItemComponent } from './restaurant-home/edit-food-item.component';
import { HomeComponent } from './home/home.component';
import { FoodlistComponent } from './foodlist/foodlist.component';
import { OrdersComponent } from './orders/orders.component';

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
  },
  {
    path: 'foodlist',
    component: FoodlistComponent,
    data: {
      title: 'Food List',
    },
  },
  {
    path: 'orders',
    component: OrdersComponent,
    data: {
      title: 'Orders',
    },
  }
];
