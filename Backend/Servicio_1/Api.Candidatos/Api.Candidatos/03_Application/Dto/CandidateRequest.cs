namespace Api.Candidatos._03_Application.Dto;

public class CandidateRequest
{
    public required int Id { get; set; }
    public required string UserName { get; set; }
    public required string LastName { get; set; }
    public required string Country { get; set; }
    public required int Votes { get; set; }
    public required string Photo { get; set; }
    public required string UserDescription { get; set; }
}
