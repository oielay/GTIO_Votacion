using Api.Candidatos._03_Application.Dto;
using Api.Candidatos._03_Application.Services;
using Api.Candidatos.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Api.Candidatos.Controllers;

[ApiController]
[Route("api/Candidates")]
public class CandidatesController : ControllerBase
{
    private readonly ICandidateService _service;

    public CandidatesController(ICandidateService service)
    {
        _service = service;
    }

    [Authorize]
    [HttpGet("Test")]
    public async Task<ActionResult<string>> GetTest()
    {
        return "hola";
    }

    [HttpGet("ObtenerTodosCandidatos")]
    public async Task<ActionResult<IEnumerable<Candidate>>> GetCandidatos()
    {
        return Ok(await _service.GetAllCandidatesAsync());
    }

    [HttpGet("ObtenerCandidatoPorId/{id}")]
    public async Task<ActionResult<Candidate>> GetCandidato(int id)
    {
        var candidate = await _service.GetCandidateByIdAsync(id);
        if (candidate == null)
            return NotFound();
        return candidate;
    }

    [HttpGet("ObtenerDatosPorNombreYApellido")]
    public async Task<ActionResult<IEnumerable<Candidate>>> BuscarCandidatos([FromQuery] string nombre, [FromQuery] string apellido)
    {
        return Ok(await _service.SearchCandidatesAsync(nombre, apellido));
    }

    [HttpPost("InsertarNuevoCandidato")]
    public async Task<ActionResult<Candidate>> CrearCandidato(CandidateRequest candidate)
    {
        await _service.AddCandidateAsync(candidate);
        return CreatedAtAction(nameof(GetCandidato), new { id = candidate.Id }, candidate);
    }

    [HttpPut("ActualizarVotosCandidato")]
    public async Task<IActionResult> ActualizarCandidato(VotosRequest votes)
    {
        try
        {
            await _service.UpdateCandidateAsync(votes);
        }
        catch (DbUpdateConcurrencyException)
        {
            return NotFound();
        }
        return NoContent();
    }

    [HttpDelete("EliminarCandidato/{id}")]
    public async Task<IActionResult> EliminarCandidato(int id)
    {
        await _service.DeleteCandidateAsync(id);
        return NoContent();
    }

    [HttpGet("ObtenerVotosCadidato/{id}")]
    public async Task<ActionResult<object>> ObtenerNumeroVotos(int id)
    {
        var votes = await _service.GetCandidateVotesAsync(id);
        return Ok(new { id, votos = votes });
    }
}
