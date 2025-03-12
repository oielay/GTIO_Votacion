namespace Api.Candidatos._03_Application.Services;

public interface IAuthService
{
    bool ValidateUserCredentials(string username, string password);
    string GenerateJwtToken(string username);
    bool RegisterUser(string username, string password);
}