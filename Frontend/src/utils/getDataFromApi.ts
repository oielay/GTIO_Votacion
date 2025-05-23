const apiUrl = import.meta.env.PUBLIC_API_URL;
const apiKey = "Z3Rpby12b3RhY2lvbi1hcGkta2V5IGhheSBxdWUgYWxhcmdhciBwYXJhIGxsZWdhciBhIDMwIGNhcmFjdGVyZXM"; //import.meta.env.PUBLIC_API_KEY;

interface Participant {
  id: number;
  userName: string;
  userImage: string;
  imageVoting: string;
  votes: number;
  features: string[];
  userDescription: string;
}

let PARTICIPANTS: Participant[] = [];

export async function obtenerTodosCandidatos() {
  const response = await fetch(
    `${apiUrl}/api/Candidates/ObtenerTodosCandidatos`,
    {
      method: "GET",
      headers: { "Content-Type": "application/json",
                 "x-api-key": apiKey},
    }
  );

  if (!response.ok) {
    throw new Error(`Failed to fetch participants: ${response.statusText}`);
  }

  PARTICIPANTS = await response.json();

  return PARTICIPANTS;
}

export async function actualizarVotosCandidato(
  participantId: number,
  votos: number
) {
  const response = await fetch(
    `${apiUrl}/api/Candidates/ActualizarVotosCandidato`,
    {
      method: "PUT",
      headers: { "Content-Type": "application/json",
                 "x-api-key": apiKey},
      body: JSON.stringify({ votes: votos, id: participantId }),
    }
  );

  if (!response.ok) {
    throw new Error(`Failed to update votes: ${response.statusText}`);
  }

  const text = await response.text();
  return text ? JSON.parse(text) : null;
}

export async function obtenerVotosCandidato(id: number) {
  const response = await fetch(
    `${apiUrl}/api/Candidates/ObtenerVotosCandidato/${id}`,
    {
      method: "GET",
      headers: { "Content-Type": "application/json",
                 "x-api-key": apiKey},
    }
  );

  if (!response.ok) {
    throw new Error(`Failed to fetch votes: ${response.statusText}`);
  }

  return await response.json();
}
