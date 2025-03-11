import { getPieChartData } from '../src/utils/charts.ts';

describe('getPieChartData', () => {
  it('should return correct pie chart data', () => {
    const { data, options } = getPieChartData();

    expect(data.labels).toEqual([
      'Pedro Sánchez',
      'Mariano Rajoy',
      'Albert Rivera',
      'Pablo Iglesias',
    ]);

    const totalVotes = 50 + 30 + 20 + 10;
    const expectedPercentages = [
      (50 / totalVotes) * 100,
      (30 / totalVotes) * 100,
      (20 / totalVotes) * 100,
      (10 / totalVotes) * 100,
    ];

    expect(data.datasets[0].data).toEqual(expectedPercentages);
    expect(options.plugins.tooltip.callbacks.label).toBeDefined();
  });
});
