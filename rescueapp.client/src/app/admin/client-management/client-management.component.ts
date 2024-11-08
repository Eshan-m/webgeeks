import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-client-management',
  templateUrl: './client-management.component.html',
  styleUrls: ['./client-management.component.scss']
})
export class ClientManagementComponent implements OnInit {
  clients = [
    { name: 'John Doe', email: 'johndoe@example.com', phone: '123-456-7890' },
    { name: 'Jane Smith', email: 'janesmith@example.com', phone: '098-765-4321' }
  ];

  constructor() { }

  ngOnInit(): void { }

  deleteClient(index: number): void {
    this.clients.splice(index, 1);
  }
}
