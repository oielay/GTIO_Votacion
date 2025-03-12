using Api.Candidatos._01_Models;
using Api.Candidatos.Infraestructura;

namespace Api.Candidatos._02_Infraestructura.Repositories;

public class UserRepository : IUserRepository
{
    private readonly EntityDbContext _context;

    public UserRepository(EntityDbContext context)
    {
        _context = context;
    }

    public User GetUserByUsername(string username)
    {
        return _context.Users.FirstOrDefault(u => u.Username == username);
    }

    public void AddUser(User user)
    {
        _context.Users.Add(user);
        _context.SaveChanges();
    }
}
