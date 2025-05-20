import Chart from "chart.js/auto";
import * as chartsHelper from "./charts.ts";
import { obtenerTodosCandidatos } from "./getDataFromApi.ts";

declare global {
  var pieChart: Chart;
  var barChart: Chart;
}

export async function getGeneralData() {
  const participants = await obtenerTodosCandidatos();
  const participantNames = participants.map((participant) => {
    return participant.userName;
  });

  const votes = participants.map((participant) => {
    return participant.votes;
  });
  const voteCounts = Object.values(votes) as number[];
  const totalVotes = voteCounts.reduce((a, b) => a + b, 0);
  const votePercentages = voteCounts.map((count) => (count / totalVotes) * 100);

  return { participantNames, voteCounts, votePercentages };
}

export async function getPieChartData() {
  const { participantNames, votePercentages } =
    await chartsHelper.getGeneralData();

  const data = {
    labels: participantNames,
    datasets: [
      {
        data: votePercentages,
        backgroundColor: ["#FF6384", "#36A2EB", "#FFCE56", "#4BC0C0"],
      },
    ],
  };

  const options = {
    responsive: true,
    maintainAspectRatio: true,
    plugins: {
      legend: {
        position: "top" as const,
      },
      tooltip: {
        callbacks: {
          label: function (tooltipItem: any) {
            const label = tooltipItem.label || "";
            const value = tooltipItem.raw as number;
            return label + ": " + value.toFixed(2) + "%";
          },
        },
      },
    },
  };

  return { data, options };
}

export async function getBarChartData() {
  const { participantNames, voteCounts } = await chartsHelper.getGeneralData();

  const data = {
    labels: participantNames,
    datasets: [
      {
        label: "Votos por participante",
        data: voteCounts,
        backgroundColor: ["#FF6384", "#36A2EB", "#FFCE56", "#4BC0C0"],
      },
    ],
  };

  const options = {
    responsive: true,
    maintainAspectRatio: true,
    scales: {
      y: {
        beginAtZero: true,
      },
    },
    plugins: {
      legend: {
        display: false,
      },
    },
  };

  return { data, options };
}

export async function updateCharts() {
  globalThis.pieChart.data = (await chartsHelper.getPieChartData()).data;

  globalThis.barChart.data = (await chartsHelper.getBarChartData()).data;

  globalThis.pieChart.update();
  globalThis.barChart.update();
}

export async function renderCharts() {
  const pieChartElement = document.getElementById(
    "pieChart"
  ) as HTMLCanvasElement;
  const barChartElement = document.getElementById(
    "barChart"
  ) as HTMLCanvasElement;

  if (pieChartElement && barChartElement) {
    const ctxPie = pieChartElement.getContext("2d");
    const ctxBar = barChartElement.getContext("2d");

    if (!ctxPie || !ctxBar) {
      return;
    }

    globalThis.pieChart = new Chart(ctxPie, {
      type: "pie",
      data: (await chartsHelper.getPieChartData()).data,
      options: (await chartsHelper.getPieChartData()).options,
    });

    globalThis.barChart = new Chart(ctxBar, {
      type: "bar",
      data: (await chartsHelper.getBarChartData()).data,
      options: (await chartsHelper.getBarChartData()).options,
    });
  }
}
