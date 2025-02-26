using Microsoft.EntityFrameworkCore;

namespace Api.Candidatos.Models;

public class EntityDbContext: DbContext
{
    public EntityDbContext(DbContextOptions<EntityDbContext> options) : base(options) { }

    public DbSet<Candidate> Candidates { get; set; }
}