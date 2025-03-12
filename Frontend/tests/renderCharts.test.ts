import * as chartsHelper from '../src/utils/charts';
import 'jest-canvas-mock';

describe('renderCharts', () => {
    let pieCanvas: HTMLCanvasElement;
    let barCanvas: HTMLCanvasElement;

    beforeEach(() => {
        pieCanvas = document.createElement('canvas');
        pieCanvas.id = 'pieChart';
        document.body.appendChild(pieCanvas);

        barCanvas = document.createElement('canvas');
        barCanvas.id = 'barChart';
        document.body.appendChild(barCanvas);

        jest.spyOn(chartsHelper, 'getBarChartData');
        jest.spyOn(chartsHelper, 'getPieChartData');
    });

    afterEach(() => {
        document.body.innerHTML = '';
        jest.clearAllMocks();
    });

    it('should not render any chart if neither canvas exists', () => {
        document.body.innerHTML = '';

        chartsHelper.renderCharts();

        expect(chartsHelper.getBarChartData).not.toHaveBeenCalled();
        expect(chartsHelper.getPieChartData).not.toHaveBeenCalled();
    });

    it('should only render the pie chart if the bar chart does not exist', () => {
        document.getElementById('barChart')?.remove();

        chartsHelper.renderCharts();

        expect(chartsHelper.getPieChartData).not.toHaveBeenCalled();
        expect(chartsHelper.getBarChartData).not.toHaveBeenCalled();
    });

    it('should only render the bar chart if the pie chart does not exist', () => {
        document.getElementById('pieChart')?.remove();

        chartsHelper.renderCharts();

        expect(chartsHelper.getBarChartData).not.toHaveBeenCalled();
        expect(chartsHelper.getPieChartData).not.toHaveBeenCalled();
    });

    it('should render both charts if both canvases exist', () => {
        global.ResizeObserver = class {
            observe() {}
            unobserve() {}
            disconnect() {}
        };

        chartsHelper.renderCharts();

        expect(chartsHelper.getPieChartData).toHaveBeenCalled();
        expect(chartsHelper.getBarChartData).toHaveBeenCalled();
    });
});