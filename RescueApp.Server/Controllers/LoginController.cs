using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using RescueApp.Server.Models;

namespace RescueApp.Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public LoginController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        // POST: api/login/insertuser
        [HttpPost("insertuser")]
        public async Task<IActionResult> InsertUserAsync([FromBody] User user)
        {
            if (user == null) return BadRequest("Invalid user data.");

            string sqlDataSource = _configuration.GetConnectionString("DevConnection");
            using (var connection = new SqlConnection(sqlDataSource))
            {
                try
                {
                    using (var command = new SqlCommand("InsertUser", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@UserName", user.UserName);
                        command.Parameters.AddWithValue("@Password", user.Password);
                        command.Parameters.AddWithValue("@Email", user.Email);
                        command.Parameters.AddWithValue("@UserType", user.UserRole);

                        await connection.OpenAsync();
                        var result = await command.ExecuteScalarAsync();
                        return Ok(new { success = true, permission = result });
                    }
                }
                catch (SqlException ex)
                {
                    Console.WriteLine($"SQL Exception: {ex.Message}");
                    return StatusCode(500, "Database error occurred.");
                }
            }
        }

        // GET: api/login/getuser/{username}/{password}
        [HttpGet("getuser/{username}/{password}")]
        public async Task<IActionResult> GetUserAsync(string username, string password)
        {
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
                return BadRequest("Username and password are required.");

            string sqlDataSource = _configuration.GetConnectionString("DevConnection");
            try
            {
                using (var connection = new SqlConnection(sqlDataSource))
                {
                    using (var command = new SqlCommand("ARGetuserauthority", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@Username", username);
                        command.Parameters.AddWithValue("@password", password);

                        await connection.OpenAsync();
                        var role = await command.ExecuteScalarAsync();
                        return role != null
                            ? Ok(new { success = true, role = (int)role })
                            : NotFound(new { success = false, message = "No role found for the user." });
                    }
                }
            }
            catch (SqlException ex)
            {
                Console.WriteLine($"SQL Exception: {ex.Message}");
                return StatusCode(500, "Database error occurred.");
            }
        }

        // GET: api/login/getfooditems
        [HttpGet("getfooditems")]
        public async Task<IActionResult> GetFoodItemsAsync()
        {
            string sqlDataSource = _configuration.GetConnectionString("DevConnection");
            var foodItems = new List<Dictionary<string, object>>();

            try
            {
                using (var connection = new SqlConnection(sqlDataSource))
                using (var command = new SqlCommand("GetFoodItems", connection) { CommandType = CommandType.StoredProcedure })
                {
                    await connection.OpenAsync();
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        var table = new DataTable();
                        table.Load(reader);

                        foreach (DataRow row in table.Rows)
                        {
                            var item = new Dictionary<string, object>();
                            foreach (DataColumn column in table.Columns)
                            {
                                item[column.ColumnName] = row[column];
                            }
                            foodItems.Add(item);
                        }
                    }
                }
                return Ok(foodItems);
            }
            catch (SqlException ex)
            {
                Console.WriteLine($"SQL Exception: {ex.Message}");
                return StatusCode(500, "Database error occurred.");
            }
        }

        // POST: api/login/addfooditem
        [HttpPost("addfooditem")]
        public async Task<IActionResult> InsertFoodItemAsync([FromBody] FoodItem food)
        {
            if (food == null) return BadRequest("Invalid food item data.");

            string sqlDataSource = _configuration.GetConnectionString("DevConnection");
            try
            {
                using (var connection = new SqlConnection(sqlDataSource))
                using (var command = new SqlCommand("InsertFoodItem", connection) { CommandType = CommandType.StoredProcedure })
                {
                    command.Parameters.AddWithValue("@FoodName", food.Name);
                    command.Parameters.AddWithValue("@Quantity", food.Quantity);
                    command.Parameters.AddWithValue("@ExpiryDate", food.Expiry);
                    command.Parameters.AddWithValue("@User", food.User);
                    command.Parameters.AddWithValue("@Condition", food.Condition);

                    await connection.OpenAsync();
                    var result = await command.ExecuteScalarAsync();
                    return Ok(new { success = true, result });
                }
            }
            catch (SqlException ex)
            {
                Console.WriteLine($"SQL Exception: {ex.Message}");
                return StatusCode(500, "Database error occurred.");
            }
        }

        
    }
}

