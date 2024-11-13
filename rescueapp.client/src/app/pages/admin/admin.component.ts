import { CommonModule } from '@angular/common';
import { Component, ViewEncapsulation, ViewChild } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatMenuModule } from '@angular/material/menu';
import { MatTableModule } from '@angular/material/table';
import { TablerIconsModule } from 'angular-tabler-icons';
import {
  ApexChart,
  ChartComponent,
  ApexDataLabels,
  ApexLegend,
  ApexStroke,
  ApexTooltip,
  ApexAxisChartSeries,
  ApexXAxis,
  ApexYAxis,
  ApexGrid,
  ApexPlotOptions,
  ApexFill,
  ApexMarkers,
  ApexResponsive,
  NgApexchartsModule,
} from 'ng-apexcharts';
import { RouterModule } from '@angular/router';  // Import RouterModule
import { ServiceService } from './../../../app/service.service';

export interface userChart {
  series: ApexAxisChartSeries;
  chart: ApexChart;
  dataLabels: ApexDataLabels;
  plotOptions: ApexPlotOptions;
  tooltip: ApexTooltip;
  stroke: ApexStroke;
  legend: ApexLegend;
  responsive: ApexResponsive;
}

export interface AdminData {
  TotalUsers: number;
  TotalRestaurants: number;
  TotalFoodItems: number;
  ExpiredItems: number;
}


@Component({
  selector: 'admin-dashboard',
  templateUrl: './admin.component.html',
  encapsulation: ViewEncapsulation.None,
  standalone: true,
  imports: [
    MatButtonModule,
    MatMenuModule,
    MatIconModule,
    TablerIconsModule,
    MatCardModule,
    NgApexchartsModule,
    MatTableModule,
    CommonModule,
    RouterModule,  // Import RouterModule to use routerLink
  ],
})
export class AdminComponent {
  @ViewChild('chart') chart: ChartComponent = Object.create(null);
  public userChart!: Partial<userChart> | any;

  constructor(private service: ServiceService) {
    this.userChart = {
      series: [0, 0], // default values, will be updated once data is received
      labels: ['Users', 'Restaurants'],
      chart: {
        type: 'donut',
        height: 160,
        toolbar: { show: false },
      },
      colors: ['#8dc63f', '#009688', '#ff9800'],
      plotOptions: {
        pie: {
          donut: {
            size: '75%',
          },
        },
      },
      tooltip: { enabled: false },
    };

    // Fetch the data and then update the chart
    this.login();
  }

  login() {
    this.service.getAdminData().subscribe((resp) => {
      const response = resp as AdminData;
      console.log(response);
      
      const TotalUsers = response.TotalUsers || 0; // Adjust according to actual response structure
      
      const TotalRestaurants = response?.TotalRestaurants || 0; // Adjust according to actual response structure

      // Update the chart data once response is available
      this.userChart = {
        series: [TotalUsers, TotalRestaurants],
        labels: ['Users', 'Restaurants'],
        chart: {
          type: 'pie',
          height: 160,
          toolbar: { show: false },
        },
        colors: ['#8dc63f', '#009688', '#ff9800'],
        plotOptions: {
          pie: {
            donut: {
              size: '75%',
            },
          },
        },
        tooltip: { enabled: false },
      };
    });
  }

}
