import { Routes } from '@angular/router';

import { AppSideLoginComponent } from './login/login.component';
import { AppSideRegisterComponent } from './register/register.component';
import { HomeComponent } from './../home/home.component';
import { AdminComponent } from './../../admin/admin.component';


export const AuthenticationRoutes: Routes = [
  {
    path: '',
    children: [
      {
        path: 'login',
        component: AppSideLoginComponent,
      },
      {
        path: 'register',
        component: AppSideRegisterComponent,
      },
      {
        path: 'home',
        component: HomeComponent,
      },
      {
        path: 'admin',
        component: AdminComponent,
      },
    ],
  },
];
