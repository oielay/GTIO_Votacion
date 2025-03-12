using Api.Candidatos._01_Models;

namespace Api.Candidatos._02_Infraestructura.Repositories;

public interface IUserRepository
{
    User GetUserByUsername(string username);
    void AddUser(User user);
}