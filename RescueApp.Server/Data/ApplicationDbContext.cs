// ApplicationDbContext.cs
using Microsoft.EntityFrameworkCore;
using RescueApp.Server.Models;
using System.Collections.Generic;

namespace RescueApp.Server.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

        // Define the DbSet for FoodItems
        public DbSet<FoodItem> FoodItems { get; set; }
    }
}
