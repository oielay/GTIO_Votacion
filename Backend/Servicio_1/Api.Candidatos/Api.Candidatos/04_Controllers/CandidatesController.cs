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
    private readonly IDatabaseScriptService _scriptService;

    public CandidatesController(ICandidateService service, IDatabaseScriptService scriptService)
    {
        _service = service;
        _scriptService = scriptService;
    }

    //[Authorize]
    [HttpGet("Test")]
    public ActionResult<string> GetTest()
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

    [HttpPost("InsertarNuevoCandidato")]
    public async Task<ActionResult<Candidate>> CrearCandidato(CandidateRequest candidate)
    {
        await _service.AddCandidateAsync(candidate);
        return CreatedAtAction(nameof(GetCandidato), candidate);
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

    [HttpPost("CrearBaseDeDatos")]
    public async Task<IActionResult> InicializarBD()
    {
        try
        {
            await _scriptService.EjecutarScriptAsync("init.sql");
            return Ok("Base de datos y tablas creadas correctamente.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Error al ejecutar el script: {ex.Message}");
        }
    }
}
