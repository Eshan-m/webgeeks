import { Component, OnInit } from '@angular/core';
import { ClientService } from './client.service';

@Component({
  selector: 'app-client-management',
  templateUrl: './client-management.component.html',
  styleUrls: ['./client-management.component.scss']
})
export class ClientManagementComponent implements OnInit {
  clients = [];
  filteredClients = [];
  searchQuery = '';
  selectedStatus = '';
  selectedClient = null;
  showAuditLog = false;
  auditLogs = [];

  constructor(private clientService: ClientService) { }

  ngOnInit(): void {
    this.loadClients();
  }

  loadClients(): void {
    this.clientService.getClients().subscribe(data => {
      this.clients = data;
      this.filteredClients = [...this.clients];
    });
  }

  // 1. CRUD Operations
  addClient(client): void {
    this.clientService.addClient(client).subscribe(newClient => {
      this.clients.push(newClient);
      this.applyFilters();
    });
  }

  updateClient(client): void {
    this.clientService.updateClient(client).subscribe(updatedClient => {
      const index = this.clients.findIndex(c => c.id === updatedClient.id);
      if (index > -1) {
        this.clients[index] = updatedClient;
      }
      this.applyFilters();
    });
  }

  deleteClient(id: number): void {
    this.clientService.deleteClient(id).subscribe(() => {
      this.clients = this.clients.filter(client => client.id !== id);
      this.applyFilters();
    });
  }

  // 2. Search and Filter Clients
  applyFilters(): void {
    this.filteredClients = this.clients.filter(client =>
      (client.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
        client.email.toLowerCase().includes(this.searchQuery.toLowerCase())) &&
      (this.selectedStatus ? client.status === this.selectedStatus : true)
    );
  }

  // 3. Client Status Management
  changeStatus(client, newStatus): void {
    client.status = newStatus;
    this.updateClient(client);
  }

  // 9. Data Analytics and Reports
  getClientStatistics(): any {
    const totalClients = this.clients.length;
    const activeClients = this.clients.filter(client => client.status === 'active').length;
    const inactiveClients = totalClients - activeClients;
    return { totalClients, activeClients, inactiveClients };
  }

  // 10. Customizable Client Dashboard (Display columns based on settings)
  displayedColumns = ['name', 'email', 'status', 'actions'];
  toggleColumn(column: string): void {
    const index = this.displayedColumns.indexOf(column);
    if (index > -1) {
      this.displayedColumns.splice(index, 1);
    } else {
      this.displayedColumns.push(column);
    }
  }

  // 12. Audit Logs for Client Actions
  viewAuditLogs(clientId: number): void {
    this.clientService.getClientLogs(clientId).subscribe(logs => {
      this.auditLogs = logs;
      this.showAuditLog = true;
    });
  }
}
