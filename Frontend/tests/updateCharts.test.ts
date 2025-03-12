import { updateCharts } from '../src/utils/charts.ts';

describe('updateCharts', () => {
    beforeEach(() => {
        (globalThis as any).pieChart = { update: jest.fn(), data: {} };
        (globalThis as any).barChart = { update: jest.fn(), data: {} };
    });

    it('should update both charts', () => {
        updateCharts();

        expect(globalThis.pieChart.update).toHaveBeenCalled();
        expect(globalThis.barChart.update).toHaveBeenCalled();
    });
});