using Api.Autentication._01_Models;

namespace Api.Autentication._02_Infraestructura.Repositories;

public interface IUserRepository
{
    User GetUserByUsername(string username);
    void AddUser(User user);
}
