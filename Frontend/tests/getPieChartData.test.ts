import * as chartsHelper from "../src/utils/charts.ts";

describe("getPieChartData", () => {
  it("should return the correct data and options for the pie chart", async () => {
    const mockData = {
      participantNames: ["Alice", "Bob", "Charlie"],
      voteCounts: [10, 20, 30],
      votePercentages: [16.666666666666664, 33.33333333333333, 50],
    };

    vi.spyOn(chartsHelper, "getGeneralData").mockResolvedValue(mockData);

    const result = await chartsHelper.getPieChartData();

    expect(result.data).toEqual({
      labels: ["Alice", "Bob", "Charlie"],
      datasets: [
        {
          data: [16.666666666666664, 33.33333333333333, 50],
          backgroundColor: ["#FF6384", "#36A2EB", "#FFCE56", "#4BC0C0"],
        },
      ],
    });

    expect(result.options).toEqual({
      responsive: true,
      maintainAspectRatio: true,
      plugins: {
        legend: {
          position: "top",
        },
        tooltip: {
          callbacks: {
            label: expect.any(Function),
          },
        },
      },
    });
  });
});
