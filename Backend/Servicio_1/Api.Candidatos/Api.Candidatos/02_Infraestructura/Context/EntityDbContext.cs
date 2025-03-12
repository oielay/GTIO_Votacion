using Api.Candidatos._01_Models;
using Api.Candidatos.Models;
using Microsoft.EntityFrameworkCore;

namespace Api.Candidatos.Infraestructura;

public class EntityDbContext: DbContext
{
    public EntityDbContext(DbContextOptions<EntityDbContext> options) : base(options) { }

    public DbSet<Candidate> Candidates { get; set; }
    public DbSet<User> Users { get; set; }
}