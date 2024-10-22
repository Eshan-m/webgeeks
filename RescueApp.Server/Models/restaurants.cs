using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;


namespace RescueApp.Server.Models
{
    public class Restaurant
    {
        public long Id { get; set; }                  // Primary Key, auto-incrementing
        public string Name { get; set; }              // Name of the restaurant
        public string Email { get; set; }             // Unique, non-null email of the restaurant
        public string Address { get; set; }           // Address of the restaurant
        public string PhoneNumber { get; set; }       // Contact phone number of the restaurant
        public DateTime CreatedAt { get; set; }       // Timestamp when the record was created
        public DateTime UpdatedAt { get; set; }       // Timestamp for the last update
    }
}
