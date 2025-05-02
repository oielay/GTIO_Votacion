import * as chartsHelper from "../src/utils/charts.ts";
import { obtenerTodosCandidatos } from "../src/utils/getDataFromApi.ts";

vi.mock("../src/utils/getDataFromApi.ts");

describe("getGeneralData", () => {
  it("should return correct data from api", async () => {
    (obtenerTodosCandidatos as vi.Mock).mockResolvedValue([
      {
        id: 1,
        userName: "Alice",
        imageVoting: "alice.jpg",
        votes: 10,
        features: ["Feature 1", "Feature 2"],
      },
      {
        id: 2,
        userName: "Bob",
        imageVoting: "bob.jpg",
        votes: 20,
        features: ["Feature 3", "Feature 4"],
      },
    ]);

    const result = await chartsHelper.getGeneralData();

    expect(result.participantNames).toEqual(["Alice", "Bob"]);
    expect(result.voteCounts).toEqual([10, 20]);
    expect(result.votePercentages).toEqual([
      33.33333333333333, 66.66666666666666,
    ]);
  });
});
