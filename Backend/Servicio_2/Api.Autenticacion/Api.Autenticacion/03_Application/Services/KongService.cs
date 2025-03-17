using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace Api.Autentication._03_Application.Services;

public class KongService : IKongService
{
    private readonly HttpClient _httpClient;
    
    public KongService(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }

    public void CreateConsumer(string username)
    {
        var data = new StringContent($"username={username}", Encoding.UTF8, "application/x-www-form-urlencoded");

        var response = _httpClient.PostAsync("http://kong:8001/consumers", data).Result;

        response.EnsureSuccessStatusCode();
    }

    public string AssingToken(string username)
    {
        // Paso 1: Crear la credencial JWT en Kong
        var data = new StringContent($"key={username}&algorithm=HS256", Encoding.UTF8, "application/x-www-form-urlencoded");

        // Realiza la solicitud para crear la credencial
        var response = _httpClient.PostAsync($"http://kong:8001/consumers/{username}/jwt", data).GetAwaiter().GetResult();

        // Asegúrate de que la solicitud fue exitosa
        response.EnsureSuccessStatusCode();

        // Paso 2: Obtener el secret generado por Kong
        var responseContent = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
        dynamic jsonResponse = Newtonsoft.Json.JsonConvert.DeserializeObject(responseContent);
        string secret = jsonResponse.secret;

        // Paso 3: Firmar el JWT localmente con el secret generado por Kong
        var header = new
        {
            typ = "JWT",
            alg = "HS256"
        };

        var claims = new
        {
            aud = username,
            exp = DateTimeOffset.UtcNow.AddMinutes(5).ToUnixTimeSeconds()
        };

        // Codificar el header y el claims a Base64Url (lo que cambia aquí es que usas Base64Url en lugar de Base64)
        string encodedHeader = Base64UrlEncode(System.Text.Encoding.UTF8.GetBytes(Newtonsoft.Json.JsonConvert.SerializeObject(header)));
        string encodedClaims = Base64UrlEncode(System.Text.Encoding.UTF8.GetBytes(Newtonsoft.Json.JsonConvert.SerializeObject(claims)));

        // Crear la firma HMAC con el secreto
        string signature = CreateHMACSignature($"{encodedHeader}.{encodedClaims}", secret);

        // JWT completo (encabezado + claims + firma)
        string jwtToken = $"{encodedHeader}.{encodedClaims}.{signature}";

        // Paso 4: Subir el JWT firmado a la API (o utilizarlo en futuras solicitudes)
        return jwtToken;
    }

    public string LoginToken(string username)
    {
        // Paso 1: Obtener las credenciales JWT del consumidor
        var response = _httpClient.GetAsync($"http://kong:8001/consumers/{username}/jwt").GetAwaiter().GetResult();

        // Asegúrate de que la solicitud fue exitosa
        response.EnsureSuccessStatusCode();

        // Paso 2: Leer la respuesta de la API para obtener el secret y la key
        var responseContent = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
        dynamic jsonResponse = Newtonsoft.Json.JsonConvert.DeserializeObject(responseContent);

        if (jsonResponse.data.Count == 0)
        {
            throw new Exception("No JWT credentials found for this consumer.");
        }

        // Obtener el secret y la key de la respuesta
        string secret = jsonResponse.data[0].secret;
        string key = jsonResponse.data[0].key;

        // Paso 3: Firmar el JWT localmente con el secret obtenido
        var header = new
        {
            typ = "JWT",
            alg = "HS256"
        };

        var claims = new
        {
            aud = username,
            exp = DateTimeOffset.UtcNow.AddMinutes(5).ToUnixTimeSeconds()
        };

        // Codificar el header y el claims a Base64Url (lo que cambia aquí es que usas Base64Url en lugar de Base64)
        string encodedHeader = Base64UrlEncode(System.Text.Encoding.UTF8.GetBytes(Newtonsoft.Json.JsonConvert.SerializeObject(header)));
        string encodedClaims = Base64UrlEncode(System.Text.Encoding.UTF8.GetBytes(Newtonsoft.Json.JsonConvert.SerializeObject(claims)));

        // Crear la firma HMAC con el secreto
        string signature = CreateHMACSignature($"{encodedHeader}.{encodedClaims}", secret);

        // JWT completo (encabezado + claims + firma)
        string jwtToken = $"{encodedHeader}.{encodedClaims}.{signature}";

        // Paso 4: Devolver el JWT firmado
        return jwtToken;
    }

    private string Base64UrlEncode(byte[] input)
    {
        string base64 = Convert.ToBase64String(input);
        base64 = base64.Split('=')[0]; // Eliminar los signos "=" al final.
        base64 = base64.Replace('+', '-'); // Reemplazar '+' con '-'
        base64 = base64.Replace('/', '_'); // Reemplazar '/' con '_'
        return base64;
    }

    private string CreateHMACSignature(string message, string secret)
    {
        using (var hmac = new System.Security.Cryptography.HMACSHA256(Encoding.UTF8.GetBytes(secret)))
        {
            var hash = hmac.ComputeHash(Encoding.UTF8.GetBytes(message));
            return Base64UrlEncode(hash);
        }
    }
}