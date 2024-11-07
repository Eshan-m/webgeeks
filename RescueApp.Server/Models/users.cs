using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace RescueApp.Server.Models
{
    public class users
    {
       
        public string UserName { get; set; }
        public string Email { get; set; }
        public String Password { get; set; }
        public String UserRole { get; set; }
    }


    public class FoodItem
    {
        public string name { get; set; }
        public int quantity { get; set; }
        public string expiry { get; set; }
        public string condition { get; set; }
        public string user { get; set; }
    }

    public class FoodItems
    {
        public string food_name { get; set; }
        public int Quantity { get; set; }
        public int id { get; set; }
    }

}