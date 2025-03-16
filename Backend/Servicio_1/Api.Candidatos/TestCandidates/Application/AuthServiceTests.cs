using Api.Candidatos._01_Models;
using Api.Candidatos._02_Infraestructura.Repositories;
using Api.Candidatos._03_Application.Services;
using FluentAssertions;
using Microsoft.Extensions.Configuration;
using Moq;
using System.IdentityModel.Tokens.Jwt;

namespace TestCandidates.Application;

public class AuthServiceTests
{
    private readonly Mock<IUserRepository> _userRepositoryMock;
    private readonly Mock<IConfiguration> _configMock;
    private readonly AuthService _authService;

    public AuthServiceTests()
    {
        _userRepositoryMock = new Mock<IUserRepository>();
        _configMock = new Mock<IConfiguration>();
        _authService = new AuthService(_configMock.Object, _userRepositoryMock.Object);
    }

    [Fact]
    public void ValidateUserCredentials_ShouldReturnTrue_WhenCredentialsAreValid()
    {
        // Arrange
        var username = "testuser";
        var password = "testpassword";
        var user = new User { Username = username };
        user.SetPassword(password);
        _userRepositoryMock.Setup(repo => repo.GetUserByUsername(username)).Returns(user);

        // Act
        var result = _authService.ValidateUserCredentials(username, password);

        // Assert
        result.Should().BeTrue();
    }

    [Fact]
    public void ValidateUserCredentials_ShouldReturnFalse_WhenCredentialsAreInvalid()
    {
        // Arrange
        var username = "testuser";
        var password = "wrongpassword";
        var user = new User { Username = username };
        user.SetPassword("testpassword");
        _userRepositoryMock.Setup(repo => repo.GetUserByUsername(username)).Returns(user);

        // Act
        var result = _authService.ValidateUserCredentials(username, password);

        // Assert
        result.Should().BeFalse();
    }

    [Fact]
    public void GenerateJwtToken_ShouldReturnToken_WhenCalled()
    {
        // Arrange
        var username = "testusername";
        var jwtSettings = new Dictionary<string, string>
        {
            { "JwtSettings:Secret", "EstaEsUnaLlaveSecretaMuySeguraDebeTener32Caracteres" },
            { "JwtSettings:Issuer", "testissuer" },
            { "JwtSettings:Audience", "testaudience" }
        };
        _configMock.Setup(config => config.GetSection("JwtSettings")).Returns(new ConfigurationBuilder().AddInMemoryCollection(jwtSettings).Build().GetSection("JwtSettings"));

        // Act
        var token = _authService.GenerateJwtToken(username);

        // Assert
        token.Should().NotBeNullOrEmpty();
        var handler = new JwtSecurityTokenHandler();
        var jwtToken = handler.ReadJwtToken(token);
        jwtToken.Claims.Should().Contain(c => c.Type == JwtRegisteredClaimNames.Sub && c.Value == username);
    }

    [Fact]
    public void RegisterUser_ShouldReturnTrue_WhenUserIsRegisteredSuccessfully()
    {
        // Arrange
        var username = "newuser";
        var password = "newpassword";
        _userRepositoryMock.Setup(repo => repo.GetUserByUsername(username)).Returns((User?)null);

        // Act
        var result = _authService.RegisterUser(username, password);

        // Assert
        result.Should().BeTrue();
        _userRepositoryMock.Verify(repo => repo.AddUser(It.IsAny<User>()), Times.Once);
    }

    [Fact]
    public void RegisterUser_ShouldReturnFalse_WhenUserAlreadyExists()
    {
        // Arrange
        var username = "existinguser";
        var password = "password";
        var user = new User { Username = username };
        _userRepositoryMock.Setup(repo => repo.GetUserByUsername(username)).Returns(user);

        // Act
        var result = _authService.RegisterUser(username, password);

        // Assert
        result.Should().BeFalse();
        _userRepositoryMock.Verify(repo => repo.AddUser(It.IsAny<User>()), Times.Never);
    }
}
