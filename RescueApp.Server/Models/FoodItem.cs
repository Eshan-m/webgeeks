using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;


namespace RescueApp.Server.Models
{
    public class FoodItem
    {
        public long Id { get; set; }                  // Primary Key, auto-incrementing
        public long RestaurantId { get; set; }        // Foreign Key (restaurants.id)
        public string Name { get; set; }              // Name of the food item
        public int Quantity { get; set; }             // Quantity available for the food item
        public string Condition { get; set; }         // Condition: 'fresh' or 'near-expiry'
        public DateTime ExpiryDate { get; set; }      // Expiration date of the food item
        public string Status { get; set; }            // Status: 'available', 'claimed', 'expired'
        public string Address { get; set; }           // Address of the restaurant
        public users users { get; set; }
    }
}
