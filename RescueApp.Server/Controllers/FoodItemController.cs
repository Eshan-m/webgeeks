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
    [Route("api/fooditem")]
    [ApiController]
    public class FoodItemController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public FoodItemController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        // Insert a new food item
        [HttpPost]
        [Route("insert")]
        public JsonResult InsertFoodItem(FoodItem foodItem)
        {
            string storedProc = "InsertFoodItem"; // Stored procedure name
            string sqlDataSource = _configuration.GetConnectionString("DevConnection");

            try
            {
                using (SqlConnection myCon = new SqlConnection(sqlDataSource))
                {
                    myCon.Open();
                    using (SqlCommand myCommand = new SqlCommand(storedProc, myCon))
                    {
                        myCommand.CommandType = CommandType.StoredProcedure;

                        // Add parameters to prevent SQL injection
                        myCommand.Parameters.AddWithValue("@RestaurantId", foodItem.RestaurantId);
                        myCommand.Parameters.AddWithValue("@Name", foodItem.Name);
                        myCommand.Parameters.AddWithValue("@Quantity", foodItem.Quantity);
                        myCommand.Parameters.AddWithValue("@Condition", foodItem.Condition);
                        myCommand.Parameters.AddWithValue("@ExpiryDate", foodItem.ExpiryDate);
                        myCommand.Parameters.AddWithValue("@Address", foodItem.Address);
                        myCommand.Parameters.AddWithValue("@Status", foodItem.Status);

                        myCommand.ExecuteNonQuery(); // Execute the command
                    }
                }

                return new JsonResult(new { success = true, message = "Food item inserted successfully." });
            }
            catch (Exception ex)
            {
                // Handle exceptions
                Console.WriteLine($"Exception: {ex.Message}");
                return new JsonResult(new { success = false, message = "An error occurred while inserting the food item." });
            }
        }

        // Update food item status
        [HttpPut]
        [Route("updateStatus/{id}")]
        public JsonResult UpdateFoodItemStatus(long id, string status)
        {
            string storedProc = "UpdateFoodItemStatus"; // Stored procedure name
            string sqlDataSource = _configuration.GetConnectionString("DevConnection");

            try
            {
                using (SqlConnection myCon = new SqlConnection(sqlDataSource))
                {
                    myCon.Open();
                    using (SqlCommand myCommand = new SqlCommand(storedProc, myCon))
                    {
                        myCommand.CommandType = CommandType.StoredProcedure;

                        // Add parameters to prevent SQL injection
                        myCommand.Parameters.AddWithValue("@FoodItemId", id);
                        myCommand.Parameters.AddWithValue("@Status", status);

                        myCommand.ExecuteNonQuery();
                    }
                }

                return new JsonResult(new { success = true, message = "Food item status updated successfully." });
            }
            catch (Exception ex)
            {
                // Handle exceptions
                Console.WriteLine($"Exception: {ex.Message}");
                return new JsonResult(new { success = false, message = "An error occurred while updating the food item status." });
            }
        }

        // Additional method for retrieving all food items in FoodItemController
        [HttpGet]
        [Route("getAll")]
        public JsonResult GetAllFoodItems()
        {
            string storedProc = "GetAllFoodItems"; // Stored procedure to fetch all food items
            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("DevConnection");

            try
            {
                using (SqlConnection myCon = new SqlConnection(sqlDataSource))
                {
                    myCon.Open();
                    using (SqlCommand myCommand = new SqlCommand(storedProc, myCon))
                    {
                        myCommand.CommandType = CommandType.StoredProcedure;

                        SqlDataReader reader = myCommand.ExecuteReader();
                        table.Load(reader);
                        reader.Close();
                    }
                }

                return new JsonResult(table);
            }
            catch (Exception ex)
            {
                // Handle exceptions
                Console.WriteLine($"Exception: {ex.Message}");
                return new JsonResult(new { success = false, message = "An error occurred while retrieving all food items." });
            }
        }


        // Retrieve food items by restaurant
        [HttpGet]
        [Route("getByRestaurant/{restaurantId}")]
        public JsonResult GetFoodItemsByRestaurant(int restaurantId, string status = null)
        {
            string storedProc = "GetFoodItemsByRestaurant";
            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("DevConnection");

            try
            {
                using (SqlConnection myCon = new SqlConnection(sqlDataSource))
                {
                    myCon.Open();
                    using (SqlCommand myCommand = new SqlCommand(storedProc, myCon))
                    {
                        myCommand.CommandType = CommandType.StoredProcedure;
                        myCommand.Parameters.AddWithValue("@RestaurantId", restaurantId);

                        // Add status filter if provided
                        if (!string.IsNullOrEmpty(status))
                            myCommand.Parameters.AddWithValue("@Status", status);
                        else
                            myCommand.Parameters.AddWithValue("@Status", DBNull.Value);

                        SqlDataReader reader = myCommand.ExecuteReader();
                        table.Load(reader);
                        reader.Close();
                    }
                }

                return new JsonResult(table);
            }
            catch (Exception ex)
            {
                // Handle exceptions
                Console.WriteLine($"Exception: {ex.Message}");
                return new JsonResult(new { success = false, message = "An error occurred while retrieving food items." });
            }
        }
    }
}

