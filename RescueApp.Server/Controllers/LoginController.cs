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
        public JsonResult Insertuser(User usr) // Changed 'users' to 'User'
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
                        myCommand.CommandType = CommandType.StoredProcedure;
                        myCommand.Parameters.AddWithValue("@Username", Username);
                        myCommand.Parameters.AddWithValue("@password", password);
                        object result = myCommand.ExecuteScalar();
                        if (result != null)
                        {
                            role = (int)result;
                        }
                        else
                        {
                            Console.WriteLine("No role returned from stored procedure.");
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                Console.WriteLine($"SQL Exception: {ex.Message}");
                return new JsonResult(new { success = false, message = "Database error occurred." });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception: {ex.Message}");
                return new JsonResult(new { success = false, message = "An error occurred." });
            }

            return new JsonResult(new { success = true, role });
        }

        [HttpGet]
        [Route("GetFoodItems")]
        public ActionResult<IEnumerable<Dictionary<string, object>>> GetFoodItems()
        {
            string query = "EXEC GetFoodItems";
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
                using (SqlCommand cmd = new SqlCommand("GetFoodItemsByRestaurant", myCon))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserName", restaurantUsername);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        foodItemsTable.Load(reader);
                    }
                }
                myCon.Close();
            }

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
    }
}
