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

interface month {
  value: string;
  viewValue: string;
}

export interface foodRescueChart {
  series: ApexAxisChartSeries;
  chart: ApexChart;
  dataLabels: ApexDataLabels;
  plotOptions: ApexPlotOptions;
  yaxis: ApexYAxis;
  xaxis: ApexXAxis;
  fill: ApexFill;
  tooltip: ApexTooltip;
  stroke: ApexStroke;
  legend: ApexLegend;
  grid: ApexGrid;
  marker: ApexMarkers;
}

export interface impactChart {
  series: ApexAxisChartSeries;
  chart: ApexChart;
  dataLabels: ApexDataLabels;
  plotOptions: ApexPlotOptions;
  tooltip: ApexTooltip;
  stroke: ApexStroke;
  legend: ApexLegend;
  responsive: ApexResponsive;
}

interface stats {
  id: number;
  time: string;
  color: string;
  title?: string;
  subtext?: string;
  link?: string;
}

export interface mealsData {
  id: number;
  imagePath: string;
  mealType: string;
  savedMeals: number;
  rescueLocation: string;
  status: string;
}

interface mealCards {
  id: number;
  imgSrc: string;
  title: string;
  description: string;
}

const ELEMENT_DATA: mealsData[] = [
  {
    id: 1,
    imagePath: 'assets/images/meals/meal-1.jpg',
    mealType: 'Vegetarian',
    savedMeals: 200,
    rescueLocation: 'New York City',
    status: 'Rescued',
  },
  {
    id: 2,
    imagePath: 'assets/images/meals/meal-2.png',
    mealType: 'Vegan',
    savedMeals: 150,
    rescueLocation: 'Los Angeles',
    status: 'In Progress',
  },
  {
    id: 3,
    imagePath: 'assets/images/meals/meal-3.jpg',
    mealType: 'Non-Vegetarian',
    savedMeals: 120,
    rescueLocation: 'Chicago',
    status: 'Rescued',
  },
  {
    id: 4,
    imagePath: 'assets/images/meals/meal-4.jpg',
    mealType: 'Gluten-Free',
    savedMeals: 80,
    rescueLocation: 'Toronto',
    status: 'In Progress',
  },
];

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
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
  ],
})
export class AppDashboardComponent {
  @ViewChild('chart') chart: ChartComponent = Object.create(null);

  public foodRescueChart!: Partial<foodRescueChart> | any;
  public impactChart!: Partial<impactChart> | any;

  displayedColumns: string[] = ['profile', 'mealType', 'savedMeals', 'status'];
  dataSource = ELEMENT_DATA;

  months: month[] = [
    { value: 'jan', viewValue: 'January 2024' },
    { value: 'feb', viewValue: 'February 2024' },
    { value: 'mar', viewValue: 'March 2024' },
  ];

  // Recent food rescues
  stats: stats[] = [
    {
      id: 1,
      time: '08:00 am',
      color: 'primary',
      subtext: '200 meals rescued in New York City',
    },
    {
      id: 2,
      time: '11:00 am',
      color: 'accent',
      title: 'New food rescue mission started',
      link: '#Rescue-3421',
    },
    {
      id: 3,
      time: '02:00 pm',
      color: 'success',
      subtext: '150 meals rescued in Los Angeles',
    },
    {
      id: 4,
      time: '04:00 pm',
      color: 'warning',
      title: 'Food donation made to local shelter',
      link: '#Shelter-1293',
    },
  ];

  // Meal cards
  mealCards: mealCards[] = [
    {
      id: 1,
      imgSrc: '/assets/images/meals/meal-1.jpg',
      title: 'Vegetarian Box',
      description: 'Rescued from local restaurant, includes assorted vegetables.',
    },
    {
      id: 2,
      imgSrc: '/assets/images/meals/meal-2.jpg',
      title: 'Vegan Delight',
      description: 'Healthy vegan meal, packed with nutrients.',
    },
    {
      id: 3,
      imgSrc: '/assets/images/meals/meal-3.jpg',
      title: 'Non-Vegetarian Combo',
      description: 'Includes chicken and side dishes, rescued from a café.',
    },
    {
      id: 4,
      imgSrc: '/assets/images/meals/meal-4.jpg',
      title: 'Gluten-Free Snacks',
      description: 'Assorted gluten-free snacks saved from waste.',
    },
  ];

  constructor() {
    // Food rescue chart
    this.foodRescueChart = {
      series: [
        {
          name: 'Meals Rescued',
          data: [120, 150, 200, 80, 100],
          color: '#76c7c0',
        },
        {
          name: 'Meals Wasted',
          data: [30, 40, 20, 50, 30],
          color: '#ff6f61',
        },
      ],
      chart: {
        type: 'bar',
        height: 390,
        foreColor: '#adb0bb',
        toolbar: { show: false },
      },
      xaxis: {
        categories: ['New York', 'Los Angeles', 'Chicago', 'Toronto', 'Boston'],
        labels: { style: { colors: ['#adb0bb'] } },
      },
      tooltip: { theme: 'light' },
    };

    // Environmental impact chart
    this.impactChart = {
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
