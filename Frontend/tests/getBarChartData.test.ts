import * as chartsHelper from '../src/utils/charts';

describe('getBarChartData', () => {
    it('should return the correct data and options for the bar chart', () => {
        const mockData = {
            participants: ['Alice', 'Bob', 'Charlie'],
            voteCounts: [10, 20, 30],
            votePercentages: [16.666666666666664, 33.33333333333333, 50]
        };

        jest.spyOn(chartsHelper, 'getGeneralData').mockReturnValue(mockData);

        const result = chartsHelper.getBarChartData();

        expect(result.data).toEqual({
            labels: ['Alice', 'Bob', 'Charlie'],
            datasets: [
                {
                    label: 'Votos por participante',
                    data: [10, 20, 30],
                    backgroundColor: [
                        "#FF6384",
                        "#36A2EB",
                        "#FFCE56",
                        "#4BC0C0",
                    ],
                },
            ],
        });

        expect(result.options).toEqual({
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
        });
    });
});
