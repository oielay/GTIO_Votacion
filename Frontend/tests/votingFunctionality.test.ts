import { fireEvent } from "@testing-library/dom";
import "@testing-library/jest-dom";
import {
  obtenerTodosCandidatos,
  actualizarVotosCandidato,
} from "../src/utils/getDataFromApi.ts";

jest.mock("../src/utils/getDataFromApi.ts", () => ({
  obtenerTodosCandidatos: jest.fn(),
  actualizarVotosCandidato: jest.fn(),
}));

describe("Voting Functionality", () => {
  let imageElement: HTMLImageElement;
  let featuresList: HTMLElement;
  let nameElement: HTMLElement;

  beforeEach(() => {
    document.body.innerHTML = `
        <img id="current-image" src="" alt="">
        <button id="prev-button">Previous</button>
        <button id="next-button">Next</button>
        <button class="voting-button">Vote</button>
        `;
  });

  it("should change the image, alt text, features, and name when next and previous buttons are clicked", async () => {
    (obtenerTodosCandidatos as jest.Mock).mockResolvedValue([
      {
        userName: "Alice",
        imageVoting: "alice.jpg",
        features: ["Feature 1", "Feature 2"],
      },
      {
        userName: "Bob",
        imageVoting: "bob.jpg",
        features: ["Feature 3", "Feature 4"],
      },
    ]);

    const PARTICIPANTS = await obtenerTodosCandidatos();

    const images = PARTICIPANTS.map((participant) => participant.imageVoting);
    const names = PARTICIPANTS.map((participant) => participant.userName);
    let currentIndex = 0;

    function changeImage(direction: string) {
      if (direction === "prev") {
        currentIndex = (currentIndex - 1 + images.length) % images.length;
      } else if (direction === "next") {
        currentIndex = (currentIndex + 1) % images.length;
      }

      if (imageElement) {
        imageElement.src = images[currentIndex];
        imageElement.alt = "Imagen del participante " + names[currentIndex];
      }
    }

    function changeFeatures() {
      if (featuresList) {
        featuresList.innerHTML = "";
      }

      const features = PARTICIPANTS[currentIndex].features;
      const featuresArr: string[] = features.toString().split(",");

      featuresArr.forEach((feature) => {
        const featureElement = document.createElement("li");
        featureElement.textContent = feature;
        featuresList?.appendChild(featureElement);
      });
    }

    function changeName() {
      if (nameElement) {
        nameElement.textContent = names[currentIndex];
      }
    }

    document.getElementById("prev-button")?.addEventListener("click", () => {
      changeImage("prev");
      changeFeatures();
      changeName();
    });
    document.getElementById("next-button")?.addEventListener("click", () => {
      changeImage("next");
      changeFeatures();
      changeName();
    });

    const prevButton = document.getElementById("prev-button") as HTMLElement;
    const nextButton = document.getElementById("next-button") as HTMLElement;
    imageElement = document.getElementById("current-image") as HTMLImageElement;

    document.body.innerHTML += `
            <ul class="features-list"></ul>
            <div class="name"></div>
        `;

    featuresList = document.querySelector(".features-list") as HTMLElement;
    nameElement = document.querySelector(".name") as HTMLElement;

    fireEvent.click(nextButton);
    expect(imageElement.src).toContain(images[1]);
    expect(imageElement.alt).toBe("Imagen del participante " + names[1]);
    expect(nameElement.textContent).toBe(names[1]);
    expect(featuresList.children.length).toBe(
      PARTICIPANTS[1].features.toString().split(",").length
    );

    fireEvent.click(prevButton);
    expect(imageElement.src).toContain(images[0]);
    expect(imageElement.alt).toBe("Imagen del participante " + names[0]);
    expect(nameElement.textContent).toBe(names[0]);
    expect(featuresList.children.length).toBe(
      PARTICIPANTS[0].features.toString().split(",").length
    );
  });

  it("should add a vote to the participant and show a vote message", async () => {
    (obtenerTodosCandidatos as jest.Mock).mockResolvedValue([
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

    (actualizarVotosCandidato as jest.Mock).mockResolvedValue({
      success: true,
    });

    const PARTICIPANTS = await obtenerTodosCandidatos();
    const names = PARTICIPANTS.map((participant) => participant.userName);
    const currentIndex = 0;

    async function addVoteToParticipant() {
      const participants = await obtenerTodosCandidatos();
      const participant = participants[currentIndex];

      await actualizarVotosCandidato(participant.id, participant.votes + 1);
    }

    function vote() {
      createVotedElement();
      addVoteToParticipant();
    }

    function createVotedElement() {
      const voteMessage = document.createElement("div");
      voteMessage.textContent =
        "Se ha votado correctamente al participante " + names[currentIndex];
      voteMessage.style.position = "fixed";
      voteMessage.style.top = "15%";
      voteMessage.style.left = "50%";
      voteMessage.style.transform = "translate(-50%, -15%)";
      voteMessage.style.backgroundColor = "rgba(0, 128, 0, 0.8)";
      voteMessage.style.color = "black";
      voteMessage.style.padding = "1rem";
      voteMessage.style.borderRadius = "8px";
      voteMessage.style.zIndex = "1000";
      document.body.appendChild(voteMessage);

      setTimeout(() => {
        document.body.removeChild(voteMessage);
      }, 3000);
    }

    document.querySelector(".voting-button")?.addEventListener("click", vote);

    const voteButton = document.querySelector(".voting-button") as HTMLElement;
    fireEvent.click(voteButton);

    await new Promise((resolve) => setTimeout(resolve, 0));

    const voteMessage = document.querySelector("div");
    expect(voteMessage).toHaveTextContent(
      "Se ha votado correctamente al participante " + names[currentIndex]
    );

    expect(actualizarVotosCandidato).toHaveBeenCalledWith(1, 11);
  });
});
