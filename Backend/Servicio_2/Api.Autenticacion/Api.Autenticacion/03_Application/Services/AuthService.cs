using Api.Autentication._01_Models;
using Api.Autentication._02_Infraestructura.Repositories;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace Api.Autentication._03_Application.Services;

public class AuthService : IAuthService
{
    private readonly IConfiguration _config;
    private readonly IUserRepository _userRepository;

    public AuthService(IConfiguration config, IUserRepository userRepository)
    {
        _config = config;
        _userRepository = userRepository;
    }

    public bool ValidateUserCredentials(string username, string password)
    {
        var user = _userRepository.GetUserByUsername(username);
        return user.VerifyPassword(password);
    }

    public string GenerateJwtToken(string username)
    {
        var jwtSettings = _config.GetSection("JwtSettings");
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings["Secret"]));

        var claims = new List<Claim>
        {
            new Claim(JwtRegisteredClaimNames.Sub, username),
            new Claim(ClaimTypes.Role, "Admin") // Asigna un rol
        };

        var token = new JwtSecurityToken(
            issuer: jwtSettings["Issuer"],
            audience: jwtSettings["Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddHours(1),
            signingCredentials: new SigningCredentials(key, SecurityAlgorithms.HmacSha256)
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    public bool RegisterUser(string username, string password)
    {
        if (_userRepository.GetUserByUsername(username) != null)
        {
            return false;
        }

        var user = new User { Username = username };
        user.SetPassword(password);
        _userRepository.AddUser(user);

        return true;
    }
}