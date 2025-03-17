using Api.Autentication._02_Infraestructura.Repositories;
using Api.Autentication._03_Application.Services;
using Api.Autentication._03_Application;
using Microsoft.Extensions.DependencyInjection;

namespace Api.Autentication._00_DependencyInjection;
public static class DependencyInjection
{
    public static IServiceCollection AddApplicationServices(this IServiceCollection services)
    {
        // Repositories
        services.AddScoped<IUserRepository, UserRepository>();

        // Services
        services.AddScoped<IAuthService, AuthService>();
        services.AddHttpClient(); 
        services.AddScoped<IKongService, KongService>();

        return services;
    }
}
