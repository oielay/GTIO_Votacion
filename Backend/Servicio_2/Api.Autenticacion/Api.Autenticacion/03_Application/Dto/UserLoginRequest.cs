using System.ComponentModel.DataAnnotations;

namespace Api.Autentication.Application.Dto;

public class UserLoginRequest
{
    public required string User { get; set; }
    public required string Password { get; set; }

}
