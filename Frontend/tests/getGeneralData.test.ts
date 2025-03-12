import * as chartsHelper from '../src/utils/charts.ts';

describe('getGeneralData', () => {
    beforeEach(() => {
        localStorage.clear();
    });

    it('should return correct data when localStorage is empty', () => {
        const mockData = ['Alice', 'Bob', 'Charlie'];
        jest.spyOn(chartsHelper, 'getParticipantNames').mockReturnValue(mockData);

        const result = chartsHelper.getGeneralData();

        expect(result.participants).toEqual(['Alice', 'Bob', 'Charlie']);
        expect(result.voteCounts).toEqual([0, 0, 0]);
        expect(result.votePercentages).toEqual([NaN, NaN, NaN]);
    });

    it('should return correct data when localStorage has votes', () => {
        localStorage.setItem("Alice's Votes", '10');
        localStorage.setItem("Bob's Votes", '20');
        localStorage.setItem("Charlie's Votes", '30');

        const mockData = ['Alice', 'Bob', 'Charlie'];
        jest.spyOn(chartsHelper, 'getParticipantNames').mockReturnValue(mockData);

        const result = chartsHelper.getGeneralData();

        expect(result.participants).toEqual(['Alice', 'Bob', 'Charlie']);
        expect(result.voteCounts).toEqual([10, 20, 30]);
        expect(result.votePercentages).toEqual([16.666666666666664, 33.33333333333333, 50]);
    });
});