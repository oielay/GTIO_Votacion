namespace Api.Candidatos._03_Application.Dto;

public class CandidateRequest
{
    public required int Id { get; set; }
    public required string UserName { get; set; }
    public required string UserImage { get; set; }
    public required string ImageVoting { get; set; }
    public required int Votes { get; set; }
    public required string Features { get; set; }
    public required string UserDescription { get; set; }
}
