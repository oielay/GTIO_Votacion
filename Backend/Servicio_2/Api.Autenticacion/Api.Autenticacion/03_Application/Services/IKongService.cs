namespace Api.Autentication._03_Application.Services;

public interface IKongService
{
    void CreateConsumer(string username);
    string AssingToken(string username);
    string LoginToken(string username);
}