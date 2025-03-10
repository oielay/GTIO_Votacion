using Api.Candidatos._02_Infraestructura.Repositories;
using Api.Candidatos._03_Application.Dto;
using Api.Candidatos._03_Application.Services;
using Api.Candidatos.Models;
namespace Api.Candidatos._03_Application;
public class CandidateService : ICandidateService
{
    private readonly ICandidateRepository _repository;

    public CandidateService(ICandidateRepository repository)
    {
        _repository = repository;
    }

    public async Task<IEnumerable<Candidate>> GetAllCandidatesAsync()
    {
        return await _repository.GetAllCandidatesAsync();
    }

    public async Task<Candidate?> GetCandidateByIdAsync(int id)
    {
        return await _repository.GetCandidateByIdAsync(id);
    }

    public async Task<IEnumerable<Candidate>> SearchCandidatesAsync(string firstName, string lastName)
    {
        return await _repository.SearchCandidatesAsync(firstName, lastName);
    }

    public async Task AddCandidateAsync(CandidateRequest candidate)
    {
        Candidate newCandidate = mapCandidate(candidate);
        await _repository.AddCandidateAsync(newCandidate);
    }

    public async Task UpdateCandidateAsync(VotosRequest votes)
    {
        await _repository.UpdateCandidateAsync(votes);
    }

    public async Task DeleteCandidateAsync(int id)
    {
        await _repository.DeleteCandidateAsync(id);
    }

    public async Task<int> GetCandidateVotesAsync(int id)
    {
        return await _repository.GetCandidateVotesAsync(id);
    }

    public async Task<bool> CandidateExistsAsync(int id)
    {
        return await _repository.CandidateExistsAsync(id);
    }

    public Candidate mapCandidate(CandidateRequest candidate)
    {
        return new Candidate
        {
            Id = candidate.Id,
            UserName = candidate.UserName,
            LastName = candidate.LastName,
            Country = candidate.Country,
            Votes = candidate.Votes,
            Photo = candidate.Photo,
            UserDescription = candidate.UserDescription
        };
    }
}
