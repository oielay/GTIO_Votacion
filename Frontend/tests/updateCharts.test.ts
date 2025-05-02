import * as chartsHelper from "../src/utils/charts.ts";

describe("updateCharts", () => {
  beforeEach(() => {
    (globalThis as any).pieChart = { update: vi.fn(), data: {} };
    (globalThis as any).barChart = { update: vi.fn(), data: {} };
  });

  it("should update both charts", async () => {
    const mockData = {
      participantNames: ["Alice", "Bob", "Charlie"],
      voteCounts: [10, 20, 30],
      votePercentages: [16.666666666666664, 33.33333333333333, 50],
    };

    vi.spyOn(chartsHelper, "getGeneralData").mockResolvedValue(mockData);

    await chartsHelper.updateCharts();

    expect(globalThis.pieChart.update).toHaveBeenCalled();
    expect(globalThis.barChart.update).toHaveBeenCalled();
  });
});
