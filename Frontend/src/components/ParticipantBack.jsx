import React from "react";
import "../styles/ParticipantBack.css";

export default function ParticipantBack({ userName, userDescription }) {
  return (
    <>
      <h3 className="card-heading">{userName}</h3>
      <p className="card-description">{userDescription}</p>
    </>
  );
}