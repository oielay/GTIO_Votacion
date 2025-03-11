import { renderCharts } from '../src/utils/charts.ts';

declare global {
  var pieChart: any;
  var barChart: any;
}

describe('renderCharts', () => {
  it('should render both pie and bar charts', () => {
    document.body.innerHTML = `
      <canvas id="pieChart"></canvas>
      <canvas id="barChart"></canvas>
    `;

    const pieChartElement = document.getElementById('pieChart') as HTMLCanvasElement;
    const barChartElement = document.getElementById('barChart') as HTMLCanvasElement;

    global.pieChart = jest.fn().mockImplementation(() => ({
      type: 'pie',
      data: {},
      options: {},
      update: jest.fn(),
    }));

    global.barChart = jest.fn().mockImplementation(() => ({
      type: 'bar',
      data: {},
      options: {},
      update: jest.fn(),
    }));

    renderCharts();

    expect(global.pieChart).toHaveBeenCalledTimes(1);
    expect(global.pieChart).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ type: 'pie' }));
    expect(global.barChart).toHaveBeenCalledTimes(1);
    expect(global.barChart).toHaveBeenCalledWith(expect.anything(), expect.objectContaining({ type: 'bar' }));
  });
});
