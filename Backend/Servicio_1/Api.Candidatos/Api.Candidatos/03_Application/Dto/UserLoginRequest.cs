using System.ComponentModel.DataAnnotations;

namespace Api.Candidatos.Application.Dto;

public class UserLoginRequest
{
    public required string User { get; set; }
    public required string Password { get; set; }
    
}
