const { renderCharts, getBarChartData, getPieChartData } = require('../src/utils/charts.ts');
import { Chart } from "chart.js";

jest.mock("../src/utils/charts.ts");
jest.mock("chart.js");

describe("renderCharts", () => {
    let pieChartElement: HTMLCanvasElement;
    let barChartElement: HTMLCanvasElement;
    let ctxPie: CanvasRenderingContext2D;
    let ctxBar: CanvasRenderingContext2D;

    beforeEach(() => {
        document.body.innerHTML = `
            <canvas id="pieChart"></canvas>
            <canvas id="barChart"></canvas>
        `;
        pieChartElement = document.getElementById("pieChart") as HTMLCanvasElement;
        barChartElement = document.getElementById("barChart") as HTMLCanvasElement;

        ctxPie = pieChartElement.getContext("2d") as CanvasRenderingContext2D;
        ctxBar = barChartElement.getContext("2d") as CanvasRenderingContext2D;
    });

    afterEach(() => {
        jest.clearAllMocks();
    });

    it("should render pie and bar charts when elements are present", () => {
        const mockPieChartData = { data: {}, options: {} };
        const mockBarChartData = { data: {}, options: {} };

        // Mock the return values of getPieChartData and getBarChartData
        (getPieChartData as jest.Mock).mockReturnValue(mockPieChartData);
        (getBarChartData as jest.Mock).mockReturnValue(mockBarChartData);

        // Call renderCharts
        renderCharts();

        // Check that Chart was called with the correct arguments
        expect(Chart).toHaveBeenCalledWith(ctxPie, {
            type: "pie",
            data: mockPieChartData.data,
            options: mockPieChartData.options,
        });

        expect(Chart).toHaveBeenCalledWith(ctxBar, {
            type: "bar",
            data: mockBarChartData.data,
            options: mockBarChartData.options,
        });
    });

    it("should not render charts if pieChartElement is missing", () => {
        document.body.innerHTML = `<canvas id="barChart"></canvas>`;
        renderCharts();
        expect(Chart).not.toHaveBeenCalled();
    });

    it("should not render charts if barChartElement is missing", () => {
        document.body.innerHTML = `<canvas id="pieChart"></canvas>`;
        renderCharts();
        expect(Chart).not.toHaveBeenCalled();
    });

    it("should not render charts if contexts are not available", () => {
        jest.spyOn(pieChartElement, "getContext").mockReturnValue(null);
        jest.spyOn(barChartElement, "getContext").mockReturnValue(null);

        renderCharts();

        expect(Chart).not.toHaveBeenCalled();
    });
});