using Api.Candidatos._03_Application.Dto;
using Api.Candidatos.Models;
namespace Api.Candidatos._03_Application.Services
{
    public interface ICandidateService
    {
        Task<IEnumerable<Candidate>> GetAllCandidatesAsync();
        Task<Candidate?> GetCandidateByIdAsync(int id);
        Task AddCandidateAsync(CandidateRequest candidate);
        Task UpdateCandidateAsync(VotosRequest votes);
        Task DeleteCandidateAsync(int id);
        Task<int> GetCandidateVotesAsync(int id);
        Task<bool> CandidateExistsAsync(int id);
    }
}