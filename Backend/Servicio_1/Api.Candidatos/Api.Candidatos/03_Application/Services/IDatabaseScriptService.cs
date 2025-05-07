namespace Api.Candidatos._03_Application.Services
{
    public interface IDatabaseScriptService
    {
        public Task EjecutarScriptAsync(string scriptFileName);
    }
}

