import { getBarChartData } from '../src/utils/charts.ts';

describe('getBarChartData', () => {
  it('should return correct bar chart data', () => {
    const { data, options } = getBarChartData();

    expect(data.labels).toEqual([
      'Pedro Sánchez',
      'Mariano Rajoy',
      'Albert Rivera',
      'Pablo Iglesias',
    ]);

    expect(data.datasets[0].data).toEqual([50, 30, 20, 10]);
    expect(options.scales.y.beginAtZero).toBe(true);
    expect(options.plugins.legend.display).toBe(false);
  });
});
