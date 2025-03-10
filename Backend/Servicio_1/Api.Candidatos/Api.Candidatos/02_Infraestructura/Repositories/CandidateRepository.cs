
using Api.Candidatos._03_Application.Dto;
using Api.Candidatos.Infraestructura;
using Api.Candidatos.Models;
using Microsoft.EntityFrameworkCore;

namespace Api.Candidatos._02_Infraestructura.Repositories;

public class CandidateRepository : ICandidateRepository
{
    private readonly EntityDbContext _context;

    public CandidateRepository(EntityDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<Candidate>> GetAllCandidatesAsync()
    {
        return await _context.Candidates.ToListAsync();
    }

    public async Task<Candidate?> GetCandidateByIdAsync(int id)
    {
        return await _context.Candidates.FindAsync(id);
    }

    public async Task<IEnumerable<Candidate>> SearchCandidatesAsync(string firstName, string lastName)
    {
        return await _context.Candidates
            .Where(c => c.UserName.Contains(firstName) && c.LastName.Contains(lastName))
            .ToListAsync();
    }

    public async Task AddCandidateAsync(Candidate candidate)
    {
        _context.Candidates.Add(candidate);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateCandidateAsync(VotosRequest votes)
    {
        var candidate = await _context.Candidates.FindAsync(votes.Id);
        if (candidate != null)
        {
            candidate.Votes = votes.Votes;
            await _context.SaveChangesAsync();
        }
    }

    public async Task DeleteCandidateAsync(int id)
    {
        var candidate = await _context.Candidates.FindAsync(id);
        if (candidate != null)
        {
            _context.Candidates.Remove(candidate);
            await _context.SaveChangesAsync();
        }
    }

    public async Task<int> GetCandidateVotesAsync(int id)
    {
        var candidate = await _context.Candidates.FindAsync(id);
        return candidate?.Votes ?? 0;
    }

    public async Task<bool> CandidateExistsAsync(int id)
    {
        return await _context.Candidates.AnyAsync(e => e.Id == id);
    }
}