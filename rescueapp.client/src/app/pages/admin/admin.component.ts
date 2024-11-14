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
  ApexTitleSubtitle,
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

interface FoodItem {
  id: number;
  food_name: string;
  quantity: number;
  expiration_date: string; // This can be a string, Date, or other format depending on your API
  restaurant_id: number;
}
export interface AdminData {
  TotalUsers: number;
  TotalRestaurants: number;
  TotalFoodItems: number;
  ExpiredItems: number;
}

export interface User {
  UserId: number;
  UserName: string;
  Email: string;
  UserType: string;
}


export type ChartOptions = {
  series: ApexAxisChartSeries;
  chart: ApexChart;
  dataLabels: ApexDataLabels;
  plotOptions: ApexPlotOptions;
  yaxis: ApexYAxis;
  xaxis: ApexXAxis;
  fill: ApexFill;
  title: ApexTitleSubtitle;
};


@Component({
  selector: 'admin-dashboard',
  templateUrl: './admin.component.html',
  styleUrls: ["./admin.component.css"],
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
  public chartOptions: Partial<ChartOptions>;
  users: User[] = [];
  constructor(private service: ServiceService) {
    this.userChart = {
      series: [0, 0], // default values, will be updated once data is received
      labels: ['Users', 'Restaurants'],
      chart: {
        type: 'donut',
        height: 260,
        toolbar: { show: false },
      },
      colors: ['#F5921B', '#009688'],
      plotOptions: {
        pie: {
          donut: {
            size: '85%',
          },
        },
      },
      tooltip: { enabled: false },
    };

    this.chartOptions = {
      series: [
        {
          name: "Inflation",
          data: [2.3, 3.1, 4.0, 10.1, 4.0, 3.6, 3.2, 2.3, 1.4, 0.8, 0.5, 0.2]
        }
      ],
      chart: {
        height: 350,
        type: "bar"
      },
      plotOptions: {
        bar: {
          dataLabels: {
            position: "top" // top, center, bottom
          }
        }
      },
      dataLabels: {
        enabled: true,
        formatter: function (val) {
          return val + " 🍉";
        },
        offsetY: -20,
        style: {
          fontSize: "12px",
          colors: ["#304758"]
        }
      },

      xaxis: {
        categories: [
       
        ],
        position: "top",
        labels: {
          offsetY: -18
        },
        axisBorder: {
          show: false
        },
        axisTicks: {
          show: false
        },
        crosshairs: {
          fill: {
            type: "gradient",
            gradient: {
              colorFrom: "#F5921B",
              colorTo: "#F8AE54",
              stops: [0, 100],
              opacityFrom: 0.4,
              opacityTo: 0.5
            }
          }
        },
        tooltip: {
          enabled: true,
          offsetY: -35
        }
      },
      fill: {
        type: "gradient",
        gradient: {
          shade: "light",
          type: "horizontal",
          shadeIntensity: 0.25,
          gradientToColors: undefined,
          inverseColors: true,
          opacityFrom: 1,
          opacityTo: 1,
          stops: [50, 0, 100, 100]
        }
      },
      yaxis: {
        axisBorder: {
          show: false
        },
        axisTicks: {
          show: false
        },
        labels: {
          show: false,
          formatter: function (val) {
            return val + " 🍉";
          }
        }
      },
      title: {
        text: "number of Food items",
        floating: false,
        offsetY: 320,
        align: "center",
        style: {
          color: "#444"
        }
      }
    };

    // Fetch the data and then update the chart
    this.getadmin();
    this.getFooditems();
    this.getUsers();
  }

  getadmin() {
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
        colors: ['#8dc63f', '#009688'],
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

  getFooditems() {
    this.service.getFoodItems().subscribe((resp) => {
      const response = resp as FoodItem[]; // List of food items
      console.log(response);

      // Get the current date
      const currentDate = new Date();

      // Prepare an array to store the counts of expiring items for the next 10 days
      const expiringCounts = Array(10).fill(0); // Initialize an array with 10 zeros

      // Loop through the food items and check expiration dates
      response.forEach(item => {
        const expirationDate = new Date(item.expiration_date); // Convert expiration date to Date object

        // Check if the expiration date is within the next 10 days
        if (expirationDate >= currentDate && expirationDate <= this.addDays(currentDate, 10)) {
          const daysUntilExpiration = this.getDaysUntilExpiration(currentDate, expirationDate);

          // Increment the count for the specific day (index is daysUntilExpiration)
          if (daysUntilExpiration >= 0 && daysUntilExpiration < 10) {
            expiringCounts[daysUntilExpiration]++;
          }
        }
      });

      // Prepare the chart options with the expiringCounts data
      this.chartOptions.series = [
        {
          name: "Items Expiring",
          data: expiringCounts, // Array of expiring item counts for each of the next 10 days
        }
      ];

      // Prepare the x-axis labels to represent the next 10 days
      if (this.chartOptions && this.chartOptions.xaxis) {
        this.chartOptions.xaxis.categories = this.getNext10Days(currentDate);
        this.chartOptions.xaxis = {...this.chartOptions.xaxis}
      }


      console.log('Updated chart options:', this.chartOptions);
      

    });
  }

  // Helper function to calculate the number of days until expiration
  getDaysUntilExpiration(currentDate: Date, expirationDate: Date): number {
    const timeDiff = expirationDate.getTime() - currentDate.getTime();
    const daysDiff = timeDiff / (1000 * 3600 * 24);
    return Math.floor(daysDiff); // Round down to the nearest integer
  }

  // Helper function to generate an array of next 10 days in a readable format
  getNext10Days(currentDate: Date): string[] {
    const next10Days = [];
    for (let i = 1; i <= 10; i++) {
      const futureDate = this.addDays(currentDate, i);
      const day = futureDate.getDate();
      const month = futureDate.getMonth() + 1; // Month is 0-indexed
      next10Days.push(`${month}/${day}`);
    }
    return next10Days;
  }

  // Helper function to add days to a date
  addDays(date: Date, days: number): Date {
    const result = new Date(date);
    result.setDate(result.getDate() + days);
    return result;
  }

  getUsers(): void {
    this.service.getUsers().subscribe(
      (resp) => {
        let response = resp as User[];
        console.log(response); // Log the response to the console
        this.users = response; // Store the user list in the component's property
      },
      (error) => {
        console.error('Error fetching users:', error); // Log errors if any
      }
    );
  }

}
