import { fireEvent } from '@testing-library/dom';
import '@testing-library/jest-dom';
import PARTICIPANTS from '../src/utils/participants.ts';

describe('Voting Functionality', () => {
  beforeEach(() => {
    document.body.innerHTML = `
      <img id="current-image" src="" alt="">
      <button id="prev-button">Previous</button>
      <button id="next-button">Next</button>
      <button class="voting-button">Vote</button>
    `;

    localStorage.clear();
  });

  it('should change the image and alt text when next and previous buttons are clicked', () => {
    const images = PARTICIPANTS.map((participant) => participant.image_voting);
    const names = PARTICIPANTS.map((participant) => participant.name);
    let currentIndex = 0;

    function changeImage(direction: string) {
      if (direction === "prev") {
        currentIndex = (currentIndex - 1 + images.length) % images.length;
      } else if (direction === "next") {
        currentIndex = (currentIndex + 1) % images.length;
      }
      const imageElement = document.getElementById("current-image") as HTMLImageElement;
      if (imageElement) {
        imageElement.src = images[currentIndex];
        imageElement.alt = "Imagen del participante " + names[currentIndex];
      }
    }

    document.getElementById("prev-button")?.addEventListener("click", () => changeImage("prev"));
    document.getElementById("next-button")?.addEventListener("click", () => changeImage("next"));

    const prevButton = document.getElementById('prev-button') as HTMLElement;
    const nextButton = document.getElementById('next-button') as HTMLElement;
    const imageElement = document.getElementById('current-image') as HTMLImageElement;

    fireEvent.click(nextButton);
    expect(imageElement.src).toContain(images[1]);
    expect(imageElement.alt).toBe("Imagen del participante " + names[1]);

    fireEvent.click(prevButton);
    expect(imageElement.src).toContain(images[0]);
    expect(imageElement.alt).toBe("Imagen del participante " + names[0]);
  });

  it('should add a vote to the participant and show a vote message', () => {
    const names = PARTICIPANTS.map((participant) => participant.name);
    let currentIndex = 0;

    function vote() {
      createVotedElement();
      addVoteToParticipant();
    }

    function createVotedElement() {
      const voteMessage = document.createElement("div");
      voteMessage.textContent = "Se ha votado correctamente al participante " + names[currentIndex];
      voteMessage.style.position = "fixed";
      voteMessage.style.top = "15%";
      voteMessage.style.left = "50%";
      voteMessage.style.transform = "translate(-50%, -15%)";
      voteMessage.style.backgroundColor = "rgba(0, 128, 0, 0.8)"; // Green background with some transparency
      voteMessage.style.color = "black";
      voteMessage.style.padding = "1rem";
      voteMessage.style.borderRadius = "8px";
      voteMessage.style.zIndex = "1000";
      document.body.appendChild(voteMessage);

      setTimeout(() => {
        document.body.removeChild(voteMessage);
      }, 3000);
    }

    function addVoteToParticipant() {
      const participantKey = names[currentIndex] + "'s Votes";
      const previousVotes = localStorage.getItem(participantKey);
      const newVotes = previousVotes ? parseInt(previousVotes) + 1 : 1;
      localStorage.setItem(participantKey, newVotes.toString());
    }

    document.querySelector(".voting-button")?.addEventListener("click", vote);

    const voteButton = document.querySelector('.voting-button') as HTMLElement;

    fireEvent.click(voteButton);

    const voteMessage = document.querySelector('div');
    expect(voteMessage).toHaveTextContent("Se ha votado correctamente al participante " + names[currentIndex]);

    const participantKey = names[currentIndex] + "'s Votes";
    expect(localStorage.getItem(participantKey)).toBe('1');
  });
});