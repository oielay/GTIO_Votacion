using System.ComponentModel.DataAnnotations;

namespace Api.Candidatos.Models;

public class Candidate
{
    [Key]
    public int Id { get; set; }
    public string? UserName { get; set; }
    public string? UserImage { get; set; }
    public string? ImageVoting { get; set; }
    public int? Votes { get; set; }
    public string? Features { get; set; }
    public string? UserDescription { get; set; }

}
