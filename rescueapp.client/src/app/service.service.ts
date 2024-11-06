// service.service.ts
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface FoodItem {
  id: number;
  food_name: string;
  quantity: number;
  expiration_date: Date;
  restaurant_id: number;
}

@Injectable({
  providedIn: 'root'
})
export class ServiceService {
  // Base URL for API Services
  baseUrl: string = "http://localhost:5279";
  readonly APIUrl = this.baseUrl + "/api";

  constructor(private http: HttpClient) { }

  // User Registration
  Insertuser(val: any) {
    return this.http.post(this.APIUrl + '/insertuser', val);
  }

  // User Login
  Getloggeduser(val: any, val2: any) {
    return this.http.get(this.APIUrl + '/Getuser/' + val + '/' + val2);
  }

  // Fetch Food Items - Updated to return Observable<FoodItem[]>
  getFoodItems(): Observable<FoodItem[]> {
    return this.http.get<FoodItem[]>(this.APIUrl + '/GetFoodItems');
  }

  // Add Food Item
  addFoodItem(val: any) {
    return this.http.post(this.APIUrl + '/addFoodItem', val);
  }

  // Fetch Food Items for a specific restaurant
  GetfooditemsRes(val: any) {
    return this.http.get<FoodItem[]>(this.APIUrl + '/GetfooditemsRes/' + val);
  }
}
