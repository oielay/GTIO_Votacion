using Api.Autentication._03_Application.Dto;
using Api.Autentication._03_Application.Services;
using Api.Autentication.Application.Dto;
using Microsoft.AspNetCore.Mvc;

namespace Api.Autentication.Controllers;

[Route("api/Auth")]
[ApiController]
public class AuthorizationController : ControllerBase
{
    private readonly IAuthService _authService;
    private readonly IKongService _kongService;

    public AuthorizationController(IAuthService authService, IKongService kongService)
    {
        _authService = authService;
        _kongService = kongService;
    }

    [HttpPost("Login")]
    public IActionResult Login([FromBody] UserLoginRequest loginDto)
    {
        if (_authService.ValidateUserCredentials(loginDto.User, loginDto.Password))
        {
            // var token = _authService.GenerateJwtToken(loginDto.User);
            string token = _kongService.LoginToken(loginDto.User);

            return Ok(new { token });
        }

        return Unauthorized();
    }

    [HttpPost("Register")]
    public IActionResult Register([FromBody] UserRegisterRequest registerDto)
    {
        var result = _authService.RegisterUser(registerDto.User, registerDto.Password);
        if (result)
        {
            _kongService.CreateConsumer(registerDto.User);
            string token = _kongService.AssingToken(registerDto.User);

            return Ok(new { message = "User registered successfully, token: " + token });
        }

        return BadRequest(new { message = "User registration failed" });
    }
}