import { useEffect } from "react";
import { renderCharts } from "../utils/charts.ts";
import "../styles/Results.css";

export default function Results() {
  useEffect(() => {
    renderCharts();
  }, []);

  return (
    <div id="results">
      <div id="pieChartContainer">
        <h3>Porcentaje de votos por participante</h3>
        <canvas id="pieChart"></canvas>
      </div>
      <div id="barChartContainer">
        <h3>Total de votos por participante</h3>
        <canvas id="barChart"></canvas>
      </div>
    </div>
  );
}