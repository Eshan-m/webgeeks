import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService {

  // Base URL for API Services
  private readonly baseUrl: string = "http://localhost:5279/api";

  constructor(private http: HttpClient) { }

  // User Registration
  registerUser(user: any): Observable<any> {
    return this.http.post<any>(`${this.baseUrl}/insertuser`, user);
  }

  // User Login
  loginUser(username: string, password: string): Observable<any> {
    return this.http.get<any>(`${this.baseUrl}/Getuser/${username}/${password}`);
  }

  // Get All Food Items
  getFoodItems(): Observable<any[]> {
    return this.http.get<any[]>(`${this.baseUrl}/GetFoodItems`);
  }

  // Add a Food Item
  addFoodItem(foodItem: any): Observable<any> {
    return this.http.post<any>(`${this.baseUrl}/addFoodItem`, foodItem);
  }

  // Get Food Items by Restaurant Username
  getFoodItemsByRestaurant(username: string): Observable<any[]> {
    return this.http.get<any[]>(`${this.baseUrl}/GetfooditemsRes/${username}`);
  }

  // Order Food
  orderFood(foodItemId: string, username: string, quantity: number): Observable<any> {
    return this.http.get<any>(`${this.baseUrl}/Orderfood/${foodItemId}/${username}/${quantity}`);
  }

  // Get Ordered Food Items by Username
  getOrderedFoodItems(username: string): Observable<any[]> {
    return this.http.get<any[]>(`${this.baseUrl}/Getfooditemsordered/${username}`);
  }

  // Delete a Food Item by ID
  deleteFoodItem(foodItemId: number): Observable<any> {
    return this.http.delete<any>(`${this.baseUrl}/Deletefooditem/${foodItemId}`);
  }

  // Update a Food Item
  updateFoodItem(foodItemId: number, foodItem: any): Observable<any> {
    return this.http.put<any>(`${this.baseUrl}/EditFoodItem/${foodItemId}`, foodItem);
  }

  // Get a Food Item by ID
  getFoodItemById(foodItemId: number): Observable<any> {
    return this.http.get<any>(`${this.baseUrl}/GetFoodItemById/${foodItemId}`);
  }

}
