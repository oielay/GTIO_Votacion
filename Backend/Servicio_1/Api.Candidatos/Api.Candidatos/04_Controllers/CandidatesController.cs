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
    private static readonly string ExpectedApiKey = Environment.GetEnvironmentVariable("PUBLIC_API_KEY") ?? "";
    private static readonly string AdminApiKey = Environment.GetEnvironmentVariable("ADMIN_API_KEY") ?? "";

    public CandidatesController(ICandidateService service, IDatabaseScriptService scriptService)
    {
        _service = service;
        _scriptService = scriptService;
    }

    //[Authorize]
    [HttpGet("Test")]
    public ActionResult<string> GetTest()
    {
        Console.WriteLine("== Headers recibidos ==");
        string response = string.Empty;
        foreach (var header in Request.Headers)
        {
            Console.WriteLine($"{header.Key}: {header.Value}");
            response += $"{header.Key}: {header.Value}\n";
        }
        return "Test OK: " + response;
    }

    [HttpGet("ObtenerTodosCandidatos")]
    public async Task<ActionResult<IEnumerable<Candidate>>> GetCandidatos()
    {
        if (!Request.Headers.TryGetValue("x-api-key", out var apiKey) || apiKey != ExpectedApiKey)
        {
            return Unauthorized(new { message = "API key invalid or missing" });
        }
        return Ok(await _service.GetAllCandidatesAsync());
    }

    [HttpGet("ObtenerCandidatoPorId/{id}")]
    public async Task<ActionResult<Candidate>> GetCandidato(int id)
    {
        if (!Request.Headers.TryGetValue("x-api-key", out var apiKey) || apiKey != ExpectedApiKey)
        {
            return Unauthorized(new { message = "API key invalid or missing" });
        }
        var candidate = await _service.GetCandidateByIdAsync(id);
        if (candidate == null)
            return NotFound();
        return candidate;
    }

    [HttpPost("InsertarNuevoCandidato")]
    public async Task<ActionResult<Candidate>> CrearCandidato(CandidateRequest candidate)
    {
        if (!Request.Headers.TryGetValue("x-api-key", out var apiKey) || apiKey != AdminApiKey)
        {
            return Unauthorized(new { message = "API key invalid or missing" });
        }
        await _service.AddCandidateAsync(candidate);
        return CreatedAtAction(nameof(GetCandidato), candidate);
    }

    [HttpPut("ActualizarVotosCandidato")]
    public async Task<IActionResult> ActualizarCandidato(VotosRequest votes)
    {
        if (!Request.Headers.TryGetValue("x-api-key", out var apiKey) || apiKey != ExpectedApiKey)
        {
            return Unauthorized(new { message = "API key invalid or missing" });
        }
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
        if (!Request.Headers.TryGetValue("x-api-key", out var apiKey) || apiKey != AdminApiKey)
        {
            return Unauthorized(new { message = "API key invalid or missing" });
        }
        await _service.DeleteCandidateAsync(id);
        return NoContent();
    }

    [HttpGet("ObtenerVotosCadidato/{id}")]
    public async Task<ActionResult<object>> ObtenerNumeroVotos(int id)
    {
        if (!Request.Headers.TryGetValue("x-api-key", out var apiKey) || apiKey != ExpectedApiKey)
        {
            return Unauthorized(new { message = "API key invalid or missing" });
        }
        var votes = await _service.GetCandidateVotesAsync(id);
        return Ok(new { id, votos = votes });
    }

    [HttpGet("CrearBaseDeDatos")]
    public async Task<IActionResult> InicializarBD()
    {
        if (!Request.Headers.TryGetValue("x-api-key", out var apiKey) || apiKey != AdminApiKey)
        {
            return Unauthorized(new { message = "API key invalid or missing" });
        }
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
