using Api.Autentication._01_Models;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;

namespace Api.Autentication.Infraestructura;

public class EntityDbContext : DbContext
{
    public EntityDbContext(DbContextOptions<EntityDbContext> options) : base(options) { }
    public DbSet<User> Users { get; set; }
    public DbSet<UserType> UserTypes { get; set; }
}