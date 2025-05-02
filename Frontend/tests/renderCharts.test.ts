import * as chartsHelper from "../src/utils/charts.ts";

describe("renderCharts", () => {
  let pieCanvas: HTMLCanvasElement;
  let barCanvas: HTMLCanvasElement;

  beforeEach(() => {
    pieCanvas = document.createElement("canvas");
    pieCanvas.id = "pieChart";
    document.body.appendChild(pieCanvas);

    barCanvas = document.createElement("canvas");
    barCanvas.id = "barChart";
    document.body.appendChild(barCanvas);

    vi.spyOn(chartsHelper, "getBarChartData");
    vi.spyOn(chartsHelper, "getPieChartData");
  });

  afterEach(() => {
    document.body.innerHTML = "";
    vi.clearAllMocks();
  });

  it("should not render any chart if neither canvas exists", async () => {
    document.body.innerHTML = "";

    const mockData = {
      participantNames: ["Alice", "Bob", "Charlie"],
      voteCounts: [10, 20, 30],
      votePercentages: [16.666666666666664, 33.33333333333333, 50],
    };

    vi.spyOn(chartsHelper, "getGeneralData").mockResolvedValue(mockData);

    await chartsHelper.renderCharts();

    expect(chartsHelper.getBarChartData).not.toHaveBeenCalled();
    expect(chartsHelper.getPieChartData).not.toHaveBeenCalled();
  });

  it("should only render the pie chart if the bar chart does not exist", async () => {
    document.getElementById("barChart")?.remove();

    const mockData = {
      participantNames: ["Alice", "Bob", "Charlie"],
      voteCounts: [10, 20, 30],
      votePercentages: [16.666666666666664, 33.33333333333333, 50],
    };

    vi.spyOn(chartsHelper, "getGeneralData").mockResolvedValue(mockData);

    await chartsHelper.renderCharts();

    expect(chartsHelper.getPieChartData).not.toHaveBeenCalled();
    expect(chartsHelper.getBarChartData).not.toHaveBeenCalled();
  });

  it("should only render the bar chart if the pie chart does not exist", async () => {
    document.getElementById("pieChart")?.remove();

    const mockData = {
      participantNames: ["Alice", "Bob", "Charlie"],
      voteCounts: [10, 20, 30],
      votePercentages: [16.666666666666664, 33.33333333333333, 50],
    };

    vi.spyOn(chartsHelper, "getGeneralData").mockResolvedValue(mockData);

    await chartsHelper.renderCharts();

    expect(chartsHelper.getBarChartData).not.toHaveBeenCalled();
    expect(chartsHelper.getPieChartData).not.toHaveBeenCalled();
  });

  it("should render both charts if both canvases exist", async () => {
    global.ResizeObserver = class {
      observe() {}
      unobserve() {}
      disconnect() {}
    };

    const mockData = {
      participantNames: ["Alice", "Bob", "Charlie"],
      voteCounts: [10, 20, 30],
      votePercentages: [16.666666666666664, 33.33333333333333, 50],
    };

    vi.spyOn(chartsHelper, "getGeneralData").mockResolvedValue(mockData);

    await chartsHelper.renderCharts();

    expect(chartsHelper.getPieChartData).toHaveBeenCalled();
    expect(chartsHelper.getBarChartData).toHaveBeenCalled();
  });
});
