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

    public string GenerateJwtToken(string username, string secret = null)
    {
        if (secret == null)
        {
            var response = _httpClient.GetAsync($"http://kong:8001/consumers/{username}/jwt").GetAwaiter().GetResult();
            response.EnsureSuccessStatusCode();

            var responseContent = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
            dynamic jsonResponse = Newtonsoft.Json.JsonConvert.DeserializeObject(responseContent);

            if (jsonResponse.data.Count == 0)
            {
                throw new Exception("No JWT credentials found for this consumer.");
            }

            secret = jsonResponse.data[0].secret;
        }

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

        string encodedHeader = Base64UrlEncode(System.Text.Encoding.UTF8.GetBytes(Newtonsoft.Json.JsonConvert.SerializeObject(header)));
        string encodedClaims = Base64UrlEncode(System.Text.Encoding.UTF8.GetBytes(Newtonsoft.Json.JsonConvert.SerializeObject(claims)));

        string signature = CreateHMACSignature($"{encodedHeader}.{encodedClaims}", secret);

        return $"{encodedHeader}.{encodedClaims}.{signature}";
    }

    public string AssingToken(string username)
    {
        var data = new StringContent($"key={username}&algorithm=HS256", Encoding.UTF8, "application/x-www-form-urlencoded");

        var response = _httpClient.PostAsync($"http://kong:8001/consumers/{username}/jwt", data).GetAwaiter().GetResult();
        response.EnsureSuccessStatusCode();

        var responseContent = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();
        dynamic jsonResponse = Newtonsoft.Json.JsonConvert.DeserializeObject(responseContent);
        string secret = jsonResponse.secret;

        return GenerateJwtToken(username, secret);
    }

    public string LoginToken(string username)
    {
        return GenerateJwtToken(username);
    }

    private string Base64UrlEncode(byte[] input)
    {
        string base64 = Convert.ToBase64String(input);
        base64 = base64.Split('=')[0];
        base64 = base64.Replace('+', '-');
        base64 = base64.Replace('/', '_');
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