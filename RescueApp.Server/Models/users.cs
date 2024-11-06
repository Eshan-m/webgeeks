// users.cs
namespace RescueApp.Server.Models
{
    public class User // Changed 'users' to 'User'
    {
        public string UserName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string UserRole { get; set; }
    }
}
