import Chart from 'chart.js/auto';
import PARTICIPANTS from "./participants.ts";
import * as chartsHelper from './charts.ts';

declare global {
    var pieChart: Chart;
    var barChart: Chart;
}

export function getParticipantNames() {
    return PARTICIPANTS.map((participant) => participant.name);
}

export function getGeneralData() {
    const participants = chartsHelper.getParticipantNames();

    const votes = participants.map((participant) => {
        const voteCount = localStorage.getItem(participant + "'s Votes") || "0";
        return parseInt(voteCount);
    });
    const voteCounts = Object.values(votes) as number[];
    const totalVotes = voteCounts.reduce((a, b) => a + b, 0);
    const votePercentages = voteCounts.map(
        (count) => (count / totalVotes) * 100
    );

    return { participants, voteCounts, votePercentages };
}

export function getPieChartData() {
    const { participants, votePercentages } = chartsHelper.getGeneralData();

    const data = {
        labels: participants,
        datasets: [
            {
                data: votePercentages,
                backgroundColor: [
                    "#FF6384",
                    "#36A2EB",
                    "#FFCE56",
                    "#4BC0C0",
                ],
            },
        ],
    }

    const options = {
        responsive: true,
        maintainAspectRatio: true,
        aspectRatio: 1,
        plugins: {
            legend: {
                position: "top" as const,
            },
            tooltip: {
                callbacks: {
                    label: function (tooltipItem: any) {
                        const label = tooltipItem.label || '';
                        const value = tooltipItem.raw as number;
                        return label + ": " + value.toFixed(2) + "%";
                    },
                },
            },
        },
    }

    return { data, options };
}

export function getBarChartData() {
    const { participants, voteCounts } = chartsHelper.getGeneralData();

    const data = {
        labels: participants,
        datasets: [
            {
                label: "Votos por participante",
                data: voteCounts,
                backgroundColor: [
                    "#FF6384",
                    "#36A2EB",
                    "#FFCE56",
                    "#4BC0C0",
                ],
            },
        ],
    }

    const options = {
        responsive: true,
        maintainAspectRatio: true,
        aspectRatio: 2,
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
    }

    return { data, options };
}

export function updateCharts() {
    globalThis.pieChart.data = chartsHelper.getPieChartData().data;

    globalThis.barChart.data = chartsHelper.getBarChartData().data;

    globalThis.pieChart.update();
    globalThis.barChart.update();
}

export function renderCharts() {
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
            data: chartsHelper.getPieChartData().data,
            options: chartsHelper.getPieChartData().options,
        });

        globalThis.barChart = new Chart(ctxBar, {
            type: "bar",
            data: chartsHelper.getBarChartData().data,
            options: chartsHelper.getBarChartData().options,
        });
    }
}