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

  constructor() {
    // Food rescue chart

    // Environmental impact chart
    this.userChart = {
      series: [350, 300, 450],
      labels: ['CO2 Saved (kg)', 'Water Saved (liters)', 'Energy Saved (kWh)'],
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
  }
}
