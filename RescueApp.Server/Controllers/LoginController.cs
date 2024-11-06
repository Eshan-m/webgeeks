using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using RescueApp.Server.Models;
using System.IO;


namespace RescueApp.Server.Controllers
{
    [Route("api")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public LoginController(IConfiguration configuration)
        {
            _configuration = configuration;
        }


        [HttpPost, ActionName("insertuser")]
        [Route("insertuser")]
        public JsonResult Insertuser(users usr)
        {
            string StoredProc2 = "exec InsertUser " +
                    "@UserName = '" + usr.UserName + "'," +
                    "@Password = '" + usr.Password + "'," +
                    "@Email= '" + usr.Email + "'," +
                    "@UserType= '" + usr.UserRole + "'";

            String permission;
            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("DevConnection");
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))
            {
                myCon.Open();
                using (SqlCommand myCommand = new SqlCommand(StoredProc2, myCon))
                {
                    permission = (String)myCommand.ExecuteScalar();
                    myCon.Close();
                }
            }

            return new JsonResult(permission);
        }


        [HttpGet, ActionName("Getuser")]
        [Route("Getuser/{Username}/{password}")]
        public JsonResult Getuser(string Username, string password)
        {
            string storedProcName = "ARGetuserauthority"; // Name of the stored procedure
            int role = -1; // Default value if no role is found
            string sqlDataSource = _configuration.GetConnectionString("DevConnection");

            // Check if the connection string is null or empty
            if (string.IsNullOrEmpty(sqlDataSource))
            {
                return new JsonResult(new { success = false, message = "Database connection string is not configured." });
            }

            try
            {
                using (SqlConnection myCon = new SqlConnection(sqlDataSource))
                {
                    myCon.Open();
                    using (SqlCommand myCommand = new SqlCommand(storedProcName, myCon))
                    {
                        myCommand.CommandType = CommandType.StoredProcedure; // Specify that we are using a stored procedure

                        // Add parameters to prevent SQL injection
                        myCommand.Parameters.AddWithValue("@Username", Username);
                        myCommand.Parameters.AddWithValue("@password", password);

                        // Execute the command and retrieve the return value
                        object result = myCommand.ExecuteScalar();

                        // Check if result is not null before casting
                        if (result != null)
                        {
                            role = (int)result; // Cast to int if not null
                        }
                        else
                        {

                         
                            // Handle case where no role is returned
                            Console.WriteLine("No role returned from stored procedure.");
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                // Handle SQL exceptions
                Console.WriteLine($"SQL Exception: {ex.Message}");
                return new JsonResult(new { success = false, message = "Database error occurred." });
            }
            catch (Exception ex)
            {
                // Handle general exceptions
                Console.WriteLine($"Exception: {ex.Message}");
                return new JsonResult(new { success = false, message = "An error occurred." });
            }

            // Return the result as a JSON response
            return new JsonResult(new { success = true, role });
        }



        [HttpGet]
        [Route("GetFoodItems")]
        public ActionResult<IEnumerable<Dictionary<string, object>>> GetFoodItems()
        {
            string query = "EXEC GetFoodItems"; // Your stored procedure name

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("DevConnection");

            using (SqlConnection myCon = new SqlConnection(sqlDataSource))
            {
                myCon.Open();
                using (SqlCommand myCommand = new SqlCommand(query, myCon))
                {
                    using (SqlDataReader myReader = myCommand.ExecuteReader())
                    {
                        table.Load(myReader);
                    }
                }
            }

            // Convert DataTable to List of Dictionaries
            var foodItems = new List<Dictionary<string, object>>();
            foreach (DataRow row in table.Rows)
            {
                var item = new Dictionary<string, object>();
                foreach (DataColumn column in table.Columns)
                {
                    item[column.ColumnName] = row[column];
                }
                foodItems.Add(item);
            }

            return Ok(foodItems);
        }



        [HttpPost, ActionName("addFoodItem")]
        [Route("addFoodItem")]
        public JsonResult InsertFoodItem(FoodItem food)
        {
            string StoredProc = "exec InsertFoodItem " +
                                "@FoodName = '" + food.name + "'," +
                                "@Quantity = " + food.quantity + "," +
                                "@ExpiryDate = '" + food.expiry + "'," +
                                "@User = '" + food.user + "'," +
                                "@Condition = '" + food.condition + "'";

            string result;
            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("DevConnection");
            SqlDataReader myReader;

            using (SqlConnection myCon = new SqlConnection(sqlDataSource))
            {
                myCon.Open();
                using (SqlCommand myCommand = new SqlCommand(StoredProc, myCon))
                {
                    result = (string)myCommand.ExecuteScalar();
                    myCon.Close();
                }
            }

            return new JsonResult(result);
        }




        [HttpGet]
        [Route("GetfooditemsRes/{restaurantUsername}")]
        public ActionResult<IEnumerable<Dictionary<string, object>>> GetFoodItems(string restaurantUsername)
        {
            string sqlDataSource = _configuration.GetConnectionString("DevConnection");

            DataTable foodItemsTable = new DataTable();

            using (SqlConnection myCon = new SqlConnection(sqlDataSource))
            {
                myCon.Open();

                // Use the stored procedure to get food items by restaurant username
                using (SqlCommand cmd = new SqlCommand("GetFoodItemsByRestaurant", myCon))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Pass the restaurant's username as a parameter
                    cmd.Parameters.AddWithValue("@UserName", restaurantUsername);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        foodItemsTable.Load(reader);
                    }
                }

                myCon.Close();
            }

            // Convert DataTable to List of Dictionaries for JSON serialization
            var foodItems = new List<Dictionary<string, object>>();
            foreach (DataRow row in foodItemsTable.Rows)
            {
                var item = new Dictionary<string, object>();
                foreach (DataColumn column in foodItemsTable.Columns)
                {
                    item[column.ColumnName] = row[column];
                }
                foodItems.Add(item);
            }

            return Ok(foodItems);
        }



        [HttpGet, ActionName("Orderfood")]
        [Route("Orderfood/{RecId}/{User}/{Qty}")]
        public JsonResult Orderfood(string RecId, string User, int Qty)
        {
            string storedProcName = "InsertOrderAndUpdateFoodItem"; // Name of the stored procedure
            int role = -1; // Default value if no role is found
            string sqlDataSource = _configuration.GetConnectionString("DevConnection");

            // Check if the connection string is null or empty
            if (string.IsNullOrEmpty(sqlDataSource))
            {
                return new JsonResult(new { success = false, message = "Database connection string is not configured." });
            }

            try
            {
                using (SqlConnection myCon = new SqlConnection(sqlDataSource))
                {
                    myCon.Open();
                    using (SqlCommand myCommand = new SqlCommand(storedProcName, myCon))
                    {
                        myCommand.CommandType = CommandType.StoredProcedure; // Specify that we are using a stored procedure

                        // Add parameters to prevent SQL injection
                        myCommand.Parameters.AddWithValue("@Username", User);
                        myCommand.Parameters.AddWithValue("@FoodItemId", RecId);
                        myCommand.Parameters.AddWithValue("@Quantity", Qty);

                        // Execute the command and retrieve the return value
                        object result = myCommand.ExecuteScalar();

                        // Check if result is not null before casting
                        if (result != null)
                        {
                            role = (int)result; // Cast to int if not null
                        }
                        else
                        {


                            // Handle case where no role is returned
                            Console.WriteLine("No role returned from stored procedure.");
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                // Handle SQL exceptions
                Console.WriteLine($"SQL Exception: {ex.Message}");
                return new JsonResult(new { success = false, message = "Database error occurred." });
            }
            catch (Exception ex)
            {
                // Handle general exceptions
                Console.WriteLine($"Exception: {ex.Message}");
                return new JsonResult(new { success = false, message = "An error occurred." });
            }

            // Return the result as a JSON response
            return new JsonResult(new { success = true, role });
        }







    }
}
