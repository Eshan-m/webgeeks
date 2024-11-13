import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { BlankComponent } from './layouts/blank/blank.component';
import { FullComponent } from './layouts/full/full.component';
import { RestaurantHomeComponent } from './pages/restaurant-home/restaurant-home.component';  // Import your components
import { AddFoodItemComponent } from './pages/restaurant-home/add-food-item.component';
import { EditFoodItemComponent } from './pages/restaurant-home/edit-food-item.component';
import { HomeComponent } from './pages/home/home.component';
import { FoodlistComponent } from './pages/foodlist/foodlist.component';
import { AdminComponent } from './pages/admin/admin.component';


const routes: Routes = [
  {
    path: '',
    component: FullComponent,
    children: [
      {
        path: '',

        redirectTo: 'home',


        pathMatch: 'full',
      },
      {
        path: 'dashboard',
        loadChildren: () =>
          import('./pages/pages.module').then((m) => m.PagesModule),
      },
      {
        path: 'ui-components',
        loadChildren: () =>
          import('./pages/ui-components/ui-components.module').then(
            (m) => m.UicomponentsModule
          ),
      },
      {
        path: 'extra',
        loadChildren: () =>
          import('./pages/extra/extra.module').then((m) => m.ExtraModule),
      },
      // Add the restaurant-related routes here
      {
        path: 'restaurant-home',
        component: RestaurantHomeComponent,
      },
      {
        path: 'add-food-item',
        component: AddFoodItemComponent,
      },
      {
        path: 'foodlist',
        component: FoodlistComponent,
      },
      {
        path: 'edit-food-item/:name',
        component: EditFoodItemComponent,
      },
      // Route for AdminComponent here
      {
        path: 'admin',
        component: AdminComponent,
      },
    ],
  },
  {
    path: '',
    component: BlankComponent,
    children: [
      {
        path: 'authentication',
        loadChildren: () =>
          import('./pages/authentication/authentication.module').then(
            (m) => m.AuthenticationModule
          ),
      },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
