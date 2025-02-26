using Api.Candidatos.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Api.Candidatos.Controllers;

[ApiController]
[Route("[controller]")]
public class CandidatesController : ControllerBase
{
    private readonly EntityDbContext _context;


    public CandidatesController(EntityDbContext context)
    {
        _context = context;
    }

    // GET: api/candidatos
    [HttpGet("ObtenerTodosCandidatos")]
    public async Task<ActionResult<IEnumerable<Candidate>>> GetCandidatos()
    {
        return await _context.Candidates.ToListAsync();
    }

    // GET: api/candidatos/{id}
    [HttpGet("ObtenerCandidatoPorId/{id}")]
    public async Task<ActionResult<Candidate>> GetCandidato(int id)
    {
        var candidate = await _context.Candidates.FindAsync(id);
        if (candidate == null)
            return NotFound();
        return candidate;
    }

    // GET: api/candidatos/buscar?nombre=Juan&apellido=Pérez
    [HttpGet("ObtenerDatosPorNombreYApellido")]
    public async Task<ActionResult<IEnumerable<Candidate>>> BuscarCandidatos([FromQuery] string nombre, [FromQuery] string apellido)
    {
        var candidates = await _context.Candidates
            .Where(c => c.UserName.Contains(nombre) && c.LastName.Contains(apellido))
            .ToListAsync();
        return candidates;
    }

    // POST: api/candidatos
    [HttpPost("InsertarNuevoCandidato")]
    public async Task<ActionResult<Candidate>> CrearCandidato(Candidate candidate)
    {
        _context.Candidates.Add(candidate);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetCandidato), new { id = candidate.Id }, candidate);
    }

    // PUT: api/candidatos/{id}
    [HttpPut("ActualizarDatosCandidato/{id}")]
    public async Task<IActionResult> ActualizarCandidato(int id, Candidate candidate)
    {
        if (id != candidate.Id)
            return BadRequest();

        _context.Entry(candidate).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!CandidatoExists(id))
                return NotFound();
            else
                throw;
        }
        return NoContent();
    }

    // DELETE: api/candidatos/{id}
    [HttpDelete("EliminarCandidato/{id}")]
    public async Task<IActionResult> EliminarCandidato(int id)
    {
        var candidate = await _context.Candidates.FindAsync(id);
        if (candidate == null)
            return NotFound();

        _context.Candidates.Remove(candidate);
        await _context.SaveChangesAsync();
        return NoContent();
    }

    // GET: api/candidatos/votos
    // Retorna para cada candidato su ID, nombre completo y el número de votos
    [HttpGet("ObtenerVotosCadidato/{id}")]
    public async Task<ActionResult<IEnumerable<object>>> ObtenerNumeroVotos(int id)
    {
        var candidate = await _context.Candidates.FindAsync(id);
        if (candidate == null)
            return NotFound();
        var result = new { id = candidate.Id, votos = candidate.Votes };
        return Ok(result);
    }

    private bool CandidatoExists(int id)
    {
        return _context.Candidates.Any(e => e.Id == id);
    }
}
