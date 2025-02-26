﻿using System.ComponentModel.DataAnnotations;

namespace Api.Candidatos.Models;

public class Candidate
{
    [Key]
    public int Id { get; set; }

    // Asegúrate de que estas propiedades coincidan con las columnas de tu tabla
    public string? UserName { get; set; }
    public string? LastName { get; set; }
    public string? Country { get; set; }
    public int? Votes { get; set; }
    public string? Photo { get; set; }
    public string? UserDescription { get; set; }

}
