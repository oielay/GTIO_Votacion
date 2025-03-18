using System.ComponentModel.DataAnnotations;
using System.Security.Cryptography;
using System.Text;

namespace Api.Autentication._01_Models;

public class UserType
{
    public int Id { get; set; }
    public string TypeName { get; set; }
}