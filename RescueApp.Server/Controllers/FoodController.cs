// FoodController.cs
using Microsoft.AspNetCore.Mvc;
using RescueApp.Server.Data; // Import the namespace for ApplicationDbContext
using RescueApp.Server.Models; // Import the namespace for FoodItem model
using System.Collections.Generic;
using System.Linq;

namespace RescueApp.Server.Controllers // Ensure this matches your project's namespace
{
    [Route("api/[controller]")]
    [ApiController]
    public class FoodController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public FoodController(ApplicationDbContext context)
        {
            _context = context;
        }

        // Endpoint for fetching all food items
        [HttpGet]
        public IActionResult GetAllFoodItems()
        {
            var foodItems = _context.FoodItems.ToList();
            return Ok(foodItems);
        }

        // Search food items by name
        [HttpGet("search")]
        public IActionResult SearchFoodItems([FromQuery] string query)
        {
            if (string.IsNullOrWhiteSpace(query))
            {
                return BadRequest("Query parameter is required.");
            }

            var filteredFoodItems = _context.FoodItems
                .Where(item => item.FoodName.Contains(query)) // Assuming the property name is FoodName
                .ToList();

            return Ok(filteredFoodItems);
        }
    }
}
