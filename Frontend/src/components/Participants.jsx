// src/components/Participants.tsx
import { useEffect, useState } from "react";
import ParticipanteFront from "./ParticipantFront";
import ParticipanteBack from "./ParticipantBack";

import "../styles/Participants.css";
import { obtenerTodosCandidatos } from "../utils/getDataFromApi";

export default function Participants() {
  const [participants, setParticipants] = useState([]);

  useEffect(() => {
    async function fetchData() {
      const data = await obtenerTodosCandidatos();
      setParticipants(data);
    }
    fetchData();
  }, []);

  const handleToggle = (e) => {
    const card = e.currentTarget.closest(".flip-card");
    if (card) card.classList.toggle("active");
  };

  return (
    <>
      <h2>Participantes</h2>
      <div className="card-container">
        {participants.map((participant) => (
          <div key={participant.id} className="flip-card">
            <div className="flip-card-inner">
              <div className="flip-card-front">
                <div className="icon-circle info-icon" onClick={handleToggle}>
                  <img src="/icons/info.svg" alt="Info icon" />
                </div>
                <ParticipanteFront {...participant} />
              </div>
              <div className="flip-card-back">
                <div className="icon-circle close-icon" onClick={handleToggle}>
                  <img src="/icons/close.svg" alt="Close icon" />
                </div>
                <ParticipanteBack {...participant} />
              </div>
            </div>
          </div>
        ))}
      </div>
    </>
  );
}