import { Component } from '@angular/core';
import { ServiceService } from './../../../../app/service.service';
import { Router } from '@angular/router';
import Swal from 'sweetalert2';


@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
})
export class AppSideLoginComponent {
  constructor(private router: Router, private service: ServiceService) { }

  Username: string = "";
  password: string = "";
  role: number | null = null;


  login() {
    console.log(this.Username);
    this.service.Getloggeduser(this.Username, this.password).subscribe(response => {

      console.log(response); // Log the entire response

      // Convert the response object to a string
      const responseString = JSON.stringify(response);
      console.log('Response as string:', responseString);

      // Split the string on commas and process it
      const responseParts = responseString.split(',');

      // Use a for loop to find the role
      for (const part of responseParts) {
        if (part.includes('"role":')) {
          const roleValue = part.split(':')[1].trim(); // Split on ':' and trim whitespace
          this.role = parseInt(roleValue); // Convert to integer
          console.log('Extracted role:', this.role);
          break; // Exit loop after finding role
        }
      }

      if ( this.role == 1) {
        localStorage.setItem('LoggedUserName', this.Username);
        localStorage.setItem('LoggedUserType', "1");
        this.router.navigate(['/dashboard']);
      }
      if (this.role == 2) {
        localStorage.setItem('LoggedUserName', this.Username);
        localStorage.setItem('LoggedUserType', "2");
        this.router.navigate(['/dashboard']);
      }


      else {
        Swal.fire('', 'Login Failed !', 'error');
        
      }

    });
  }


}
