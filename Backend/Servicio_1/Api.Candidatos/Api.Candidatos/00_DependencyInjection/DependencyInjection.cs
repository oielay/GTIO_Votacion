using Api.Candidatos._02_Infraestructura.Repositories;
using Api.Candidatos._03_Application.Services;
using Api.Candidatos._03_Application;
using Microsoft.Extensions.DependencyInjection;

namespace Api.Candidatos._00_DependencyInjection;
public static class DependencyInjection
{
    public static IServiceCollection AddApplicationServices(this IServiceCollection services)
    {
        // Repositories
        services.AddScoped<ICandidateRepository, CandidateRepository>();
        services.AddScoped<IUserRepository, UserRepository>();

        // Services
        services.AddScoped<ICandidateService, CandidateService>();
        services.AddScoped<IAuthService, AuthService>();

        return services;
    }
}
