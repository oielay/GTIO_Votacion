import "https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.js"
import PARTICIPANTS from "./participants";

declare var Chart: any;
declare global {
    var pieChart: typeof Chart;
    var barChart: typeof Chart;
}

function getGeneralData() {
    const participants = PARTICIPANTS.map((participant) => participant.name);

    const votes = PARTICIPANTS.map((participant) => {
        const voteCount = localStorage.getItem(participant.name + "'s Votes") || "0";
        return parseInt(voteCount);
    });
    const voteCounts = Object.values(votes) as number[];
    const totalVotes = voteCounts.reduce((a, b) => a + b, 0);
    const votePercentages = voteCounts.map(
        (count) => (count / totalVotes) * 100
    );

    return { participants, voteCounts, votePercentages };
}

function getPieChartData() {
    const { participants, voteCounts, votePercentages } = getGeneralData();

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
                position: "top",
            },
            tooltip: {
                callbacks: {
                    label: function (context: any) {
                        return context.label + ": " + context.raw.toFixed(2) + "%";
                    },
                },
            },
        },
    }

    return { data, options };
}

function getBarChartData() {
    const { participants, voteCounts, votePercentages } = getGeneralData();

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
    globalThis.pieChart.data = getPieChartData().data;

    globalThis.barChart.data = getBarChartData().data;

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

        globalThis.pieChart = new Chart(ctxPie, {
            type: "pie",
            data: getPieChartData().data,
            options: getPieChartData().options,
        });

        globalThis.barChart = new Chart(ctxBar, {
            type: "bar",
            data: getBarChartData().data,
            options: getBarChartData().options,
        });
    }
}


