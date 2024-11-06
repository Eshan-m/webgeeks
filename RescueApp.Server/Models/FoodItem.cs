using System;

namespace RescueApp.Server.Models
{
    public class FoodItem
    {
        public int Id { get; set; }
        public string name { get; set; }       // Lowercase 'name' for LoginController
        public int quantity { get; set; }      // Lowercase 'quantity'
        public DateTime expiry { get; set; }   // Lowercase 'expiry'
        public string condition { get; set; }  // Lowercase 'condition'
        public string user { get; set; }       // Lowercase 'user'
        public string FoodName { get; set; }   // Uppercase 'FoodName' for FoodController
    }
}
