import { Component } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ServiceService } from './../../../../app/service.service';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
})
export class AppSideRegisterComponent {
  constructor(private router: Router, private service: ServiceService) {}


  Username: string = "";
  password: string = "";
  email: string = "";
  usertype: string = "";

  form = new FormGroup({
    uname: new FormControl(''),
    email: new FormControl(''),
    password: new FormControl(''),
  });

  get f() {
    return this.form.controls;
  }

  addUser() {
    var val = {
      UserName: this.Username,
      Password: this.password,
      Email: this.email,
      UserRole: this.usertype
    };

    if ((this.Username == '') || (this.password == undefined) || (this.password == '') || (this.email == undefined) || (this.email == '')) { Swal.fire('','Please Fill Mandatory Fields!'); } else {
      this.service.Insertuser(val).subscribe(res => {
        console.log(res);
        Swal.fire('Successfull !', '', 'success');
        this.router.navigate(['/login']);
       
      }, (error => { Swal.fire('Error Occurred', '', 'error'); }));
    }
  }


  submit() {
    // console.log(this.form.value);
    this.router.navigate(['/dashboard']);
  }
}
