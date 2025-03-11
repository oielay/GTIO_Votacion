import { updateCharts } from '../src/utils/charts.ts';

describe('updateCharts', () => {
  it('should update both pie and bar charts', () => {
    globalThis.pieChart = { update: jest.fn() };
    globalThis.barChart = { update: jest.fn() };

    updateCharts();

    expect(globalThis.pieChart.update).toHaveBeenCalled();
    expect(globalThis.barChart.update).toHaveBeenCalled();
  });
});
