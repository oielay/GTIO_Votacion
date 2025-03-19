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
    "http://localhost:1234/api/Candidates/ObtenerTodosCandidatos",
    {
      method: "GET",
      headers: { "Content-Type": "application/json" },
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
    "http://localhost:1234/api/Candidates/ActualizarVotosCandidato",
    {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
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
    `http://localhost:1234/api/Candidates/ObtenerVotosCandidato/${id}`,
    {
      method: "GET",
      headers: { "Content-Type": "application/json" },
    }
  );

  if (!response.ok) {
    throw new Error(`Failed to fetch votes: ${response.statusText}`);
  }

  return await response.json();
}
