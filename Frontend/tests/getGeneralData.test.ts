import { getGeneralData } from '../src/utils/charts.ts';

describe('getGeneralData', () => {
  beforeEach(() => {
    localStorage.setItem("Pedro S�nchez's Votes", "50");
    localStorage.setItem("Mariano Rajoy's Votes", "30");
    localStorage.setItem("Albert Rivera's Votes", "20");
    localStorage.setItem("Pablo Iglesias's Votes", "10");
  });

  afterEach(() => {
    localStorage.clear();
  });

  it('should return correct participants and vote counts', () => {
    const { participants, voteCounts, votePercentages } = getGeneralData();

    expect(participants).toEqual([
      'Pedro Sánchez',
      'Mariano Rajoy',
      'Albert Rivera',
      'Pablo Iglesias',
    ]);
    expect(voteCounts).toEqual([50, 30, 20, 10]);

    const totalVotes = 50 + 30 + 20 + 10;
    expect(votePercentages).toEqual([
      (50 / totalVotes) * 100,
      (30 / totalVotes) * 100,
      (20 / totalVotes) * 100,
      (10 / totalVotes) * 100,
    ]);
  });
});
