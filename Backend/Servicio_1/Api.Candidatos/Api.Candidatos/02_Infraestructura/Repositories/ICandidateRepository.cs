using Api.Candidatos._03_Application.Dto;
using Api.Candidatos.Models;
namespace Api.Candidatos._02_Infraestructura.Repositories;
public interface ICandidateRepository
{
    Task<IEnumerable<Candidate>> GetAllCandidatesAsync();
    Task<Candidate?> GetCandidateByIdAsync(int id);
    Task<IEnumerable<Candidate>> SearchCandidatesAsync(string firstName, string lastName);
    Task AddCandidateAsync(Candidate candidate);
    Task UpdateCandidateAsync(VotosRequest votes);
    Task DeleteCandidateAsync(int id);
    Task<int> GetCandidateVotesAsync(int id);
    Task<bool> CandidateExistsAsync(int id);
}