import React from "react";
import "../styles/ParticipantFront.css";

export default function ParticipantFront({ userName, userImage }) {
  return (
    <>
      <div
        title={`Imagen del candidato ${userName}`}
        className="card-background"
        style={{ backgroundImage: `url(${userImage})` }}
      ></div>
      <h3 className="card-heading">{userName}</h3>
    </>
  );
}