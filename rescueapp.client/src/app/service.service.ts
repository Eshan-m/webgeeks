import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';


@Injectable({
  providedIn: 'root'
})
export class ServiceService {

  //Base Url for API Services

  baseUrl: string = "https://localhost:44363";

  readonly APIUrl = this.baseUrl + "/api";
  constructor(private http: HttpClient) { }

  //User Registration
  Insertuser(val: any) {
    return this.http.post(this.APIUrl + '/insertuser', val);
  }

  //User Login
  Getloggeduser(val: any, val2: any) {
    return this.http.get(this.APIUrl + '/Getuser/' + val + '/' + val2);
  }

  getFoodItems() {
    return this.http.get(this.APIUrl + '/GetFoodItems');
  }

  addFoodItem(val: any) {
    return this.http.post(this.APIUrl + '/addFoodItem', val);
  }

  GetfooditemsRes(val: any) {
    return this.http.get(this.APIUrl + '/GetfooditemsRes/' + val);
  }

  Orderfood(val: any, val2: any, val3: any) {
    return this.http.get(this.APIUrl + '/Orderfood/' + val + '/' + val2 + '/' + val3);
  }

  Getfooditemsordered(val: any) {
    return this.http.get(this.APIUrl + '/Getfooditemsordered/' + val);
  }

  Deletefooditem(val: any) {
    return this.http.get(this.APIUrl + '/Deletefooditem/' + val);
  }

  updateFoodItem(id: number, foodItem: any): Observable<any> {
    return this.http.put<any>(this.APIUrl +`/EditFoodItem/`+id, foodItem);
  }

  getFoodItemById(id: number) {
    return this.http.get(this.APIUrl + '/GetFoodItemById/'+ id);
  }
  Getresturantordered(val: any) {
    return this.http.get(this.APIUrl + '/Getresturantordered/' + val);
  }
  getAdminData() {
    return this.http.get(this.APIUrl + '/GetAdminStatistics');
  }
  getUsers() {
    return this.http.get(this.APIUrl + '/GetUsers');
  }

}
