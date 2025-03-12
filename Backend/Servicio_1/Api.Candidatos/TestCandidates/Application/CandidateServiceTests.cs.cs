using Xunit;
using FluentAssertions;
using Moq;
using Api.Candidatos._03_Application;
using Api.Candidatos._02_Infraestructura.Repositories;
using Api.Candidatos.Models;
using Api.Candidatos._03_Application.Dto;
using System.Collections.Generic;
using System.Threading.Tasks;
namespace TestCandidates.Application;

public class CandidateServiceTests
{
    private readonly Mock<ICandidateRepository> _repositoryMock;
    private readonly CandidateService _candidateService;

    public CandidateServiceTests()
    {
        _repositoryMock = new Mock<ICandidateRepository>();
        _candidateService = new CandidateService(_repositoryMock.Object);
    }
    [Fact]
    public async Task GetAllCandidatesAsync_ShouldReturnAllCandidates()
    {
        // Arrange
        var candidates = new List<Candidate> { new Candidate { Id = 1, UserName = "John" } };
        _repositoryMock.Setup(repo => repo.GetAllCandidatesAsync()).ReturnsAsync(candidates);

        // Act
        var result = await _candidateService.GetAllCandidatesAsync();

        // Assert
        result.Should().BeEquivalentTo(candidates);
    }

    [Fact]
    public async Task GetCandidateByIdAsync_ShouldReturnCandidate_WhenCandidateExists()
    {
        // Arrange
        var candidate = new Candidate { Id = 1, UserName = "John" };
        _repositoryMock.Setup(repo => repo.GetCandidateByIdAsync(1)).ReturnsAsync(candidate);

        // Act
        var result = await _candidateService.GetCandidateByIdAsync(1);

        // Assert
        result.Should().BeEquivalentTo(candidate);
    }

    [Fact]
    public async Task GetCandidateByIdAsync_ShouldReturnNull_WhenCandidateDoesNotExist()
    {
        // Arrange
        _repositoryMock.Setup(repo => repo.GetCandidateByIdAsync(1)).ReturnsAsync((Candidate?)null);

        // Act
        var result = await _candidateService.GetCandidateByIdAsync(1);

        // Assert
        result.Should().BeNull();
    }

    [Fact]
    public async Task AddCandidateAsync_ShouldCallRepositoryAddMethod()
    {
        // Arrange
        var candidateRequest = new CandidateRequest
        {
            UserName = "John",
            UserImage = "image.png",
            ImageVoting = "voting.png",
            Votes = 0,
            Features = "features",
            UserDescription = "description"
        };

        // Act
        await _candidateService.AddCandidateAsync(candidateRequest);

        // Assert
        _repositoryMock.Verify(repo => repo.AddCandidateAsync(It.IsAny<Candidate>()), Times.Once);
    }

    [Fact]
    public async Task UpdateCandidateAsync_ShouldCallRepositoryUpdateMethod()
    {
        // Arrange
        var votesRequest = new VotosRequest { Id = 1, Votes = 10 };

        // Act
        await _candidateService.UpdateCandidateAsync(votesRequest);

        // Assert
        _repositoryMock.Verify(repo => repo.UpdateCandidateAsync(votesRequest), Times.Once);
    }

    [Fact]
    public async Task DeleteCandidateAsync_ShouldCallRepositoryDeleteMethod()
    {
        // Arrange
        var candidateId = 1;

        // Act
        await _candidateService.DeleteCandidateAsync(candidateId);

        // Assert
        _repositoryMock.Verify(repo => repo.DeleteCandidateAsync(candidateId), Times.Once);
    }

    [Fact]
    public async Task GetCandidateVotesAsync_ShouldReturnVotes()
    {
        // Arrange
        var candidateId = 1;
        var votes = 10;
        _repositoryMock.Setup(repo => repo.GetCandidateVotesAsync(candidateId)).ReturnsAsync(votes);

        // Act
        var result = await _candidateService.GetCandidateVotesAsync(candidateId);

        // Assert
        result.Should().Be(votes);
    }

    [Fact]
    public async Task CandidateExistsAsync_ShouldReturnTrue_WhenCandidateExists()
    {
        // Arrange
        var candidateId = 1;
        _repositoryMock.Setup(repo => repo.CandidateExistsAsync(candidateId)).ReturnsAsync(true);

        // Act
        var result = await _candidateService.CandidateExistsAsync(candidateId);

        // Assert
        result.Should().BeTrue();
    }

    [Fact]
    public async Task CandidateExistsAsync_ShouldReturnFalse_WhenCandidateDoesNotExist()
    {
        // Arrange
        var candidateId = 1;
        _repositoryMock.Setup(repo => repo.CandidateExistsAsync(candidateId)).ReturnsAsync(false);

        // Act
        var result = await _candidateService.CandidateExistsAsync(candidateId);

        // Assert
        result.Should().BeFalse();
    }
}
