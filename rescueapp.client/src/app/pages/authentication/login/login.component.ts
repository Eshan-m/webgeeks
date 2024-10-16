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

      console.log(response); 

      const responseString = JSON.stringify(response);
      console.log('Response as string:', responseString);

      const responseParts = responseString.split(',');

      for (const part of responseParts) {
        if (part.includes('"role":')) {
          const roleValue = part.split(':')[1].trim(); 
          this.role = parseInt(roleValue); 
          console.log('Extracted role:', this.role);
          
        }
      }

      if (this.role == 1) {
        localStorage.setItem('LoggedUserName', this.Username);
        localStorage.setItem('LoggedUserType', "1");
        this.router.navigate(['/dashboard']);
      } else 
      if (this.role == 2) {
        localStorage.setItem('LoggedUserName', this.Username);
        localStorage.setItem('LoggedUserType', "2");
        this.router.navigate(['/dashboard']);
      } else {
        Swal.fire('', 'Login Failed!', 'error');
      }
    });
  }
}
