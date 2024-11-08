import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ClientService {
  private apiUrl = 'https://your-api-endpoint.com/clients'; // Replace with your API endpoint

  constructor(private http: HttpClient) { }

  getClients(): Observable<any> {
    return this.http.get<any>(this.apiUrl);
  }

  addClient(client): Observable<any> {
    return this.http.post<any>(this.apiUrl, client);
  }

  updateClient(client): Observable<any> {
    return this.http.put<any>(`${this.apiUrl}/${client.id}`, client);
  }

  deleteClient(id: number): Observable<any> {
    return this.http.delete<any>(`${this.apiUrl}/${id}`);
  }

  getClientLogs(clientId: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/${clientId}/logs`);
  }
}
