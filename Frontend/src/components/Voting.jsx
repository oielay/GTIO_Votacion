import React, { useEffect, useState } from "react";
import { obtenerTodosCandidatos, actualizarVotosCandidato } from "../utils/getDataFromApi.ts";
import { updateCharts } from "../utils/charts.ts";
import "../styles/Voting.css";

export default function Voting() {
  const [participantes, setParticipantes] = useState([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [participante, setParticipante] = useState(null);
  const [featuresArr, setFeaturesArr] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      const data = await obtenerTodosCandidatos();
      setParticipantes(data);
      if (data.length > 0) {
        setParticipante(data[0]);
        setFeaturesArr(data[0].features?.toString().split(",") ?? []);
      }
    };
    fetchData();
  }, []);

  useEffect(() => {
    if (participantes.length > 0) {
      const current = participantes[currentIndex];
      setParticipante(current);
      setFeaturesArr(current?.features?.toString().split(",") ?? []);
    }
  }, [currentIndex, participantes]);

  const handleChange = (direction) => {
    if (participantes.length === 0) return;
    const nextIndex =
      direction === "prev"
        ? (currentIndex - 1 + participantes.length) % participantes.length
        : (currentIndex + 1) % participantes.length;
    setCurrentIndex(nextIndex);
  };

  const vote = async () => {
    if (!participante) return;

    createVotedElement();
    const updatedVotes = participante.votes + 1;

    await actualizarVotosCandidato(participante.id, updatedVotes);

    const updatedList = [...participantes];
    updatedList[currentIndex] = { ...participante, votes: updatedVotes };
    setParticipantes(updatedList);

    updateCharts();
  };

  const createVotedElement = () => {
    const voteMessage = document.createElement("div");
    voteMessage.textContent = `Se ha votado correctamente al participante ${participante.userName}`;
    Object.assign(voteMessage.style, {
      position: "fixed",
      top: "15%",
      left: "50%",
      transform: "translate(-50%, -15%)",
      backgroundColor: "rgba(0, 128, 0, 0.8)",
      color: "black",
      padding: "1rem",
      borderRadius: "8px",
      zIndex: 1000,
    });
    document.body.appendChild(voteMessage);
    setTimeout(() => document.body.removeChild(voteMessage), 3000);
  };

  if (!participante) {
    return <p>Cargando participante...</p>;
  }

  return (
    <div className="vote-container">
      <h2>Votaciones</h2>
      <p>Escoja a su participante favorito para votar:</p>
      <div className="candidate">
        <div className="participant">
          <div className="image-container">
            <button onClick={() => handleChange("prev")} className="arrow">
              ←
            </button>
            <img
              id="current-image"
              src={participante.imageVoting}
              alt={`Imagen del participante ${participante.userName}`}
            />
            <button onClick={() => handleChange("next")} className="arrow">
              →
            </button>
          </div>
          <p className="name">{participante.userName}</p>
        </div>
        <div className="features">
          <h2>Características</h2>
          <p className="features-participant-name">
            Conozca las características del participante:
          </p>
          <ul className="features-list">
            {featuresArr.map((feature, index) => (
              <li key={index}>{feature}</li>
            ))}
          </ul>
          <button className="voting-button" onClick={vote}>
            Votar
          </button>
        </div>
      </div>
    </div>
  );
}