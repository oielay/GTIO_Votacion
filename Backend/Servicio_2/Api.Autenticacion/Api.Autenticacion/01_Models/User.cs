using System.ComponentModel.DataAnnotations;
using System.Security.Cryptography;
using System.Text;

namespace Api.Autentication._01_Models;

public class User
{
    [Key]
    public int Id { get; set; }
    public string? Username { get; set; }
    public string? PasswordHash { get; private set; }
    public string? PasswordSalt { get; private set; }
    public int UserTypeId { get; private set; } = 1;
    public UserType UserType { get; set; }

    public void SetPassword(string password)
    {
        using (var hmac = new HMACSHA512())
        {
            PasswordSalt = Convert.ToBase64String(hmac.Key);
            PasswordHash = Convert.ToBase64String(hmac.ComputeHash(Encoding.UTF8.GetBytes(password)));
        }
    }

    public bool VerifyPassword(string password)
    {
        if (PasswordSalt == null || PasswordHash == null)
            return false;

        using (var hmac = new HMACSHA512(Convert.FromBase64String(PasswordSalt)))
        {
            var computedHash = hmac.ComputeHash(Encoding.UTF8.GetBytes(password));
            return Convert.ToBase64String(computedHash) == PasswordHash;
        }
    }
}