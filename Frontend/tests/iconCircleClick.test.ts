import { fireEvent } from "@testing-library/dom";
import "@testing-library/jest-dom";

describe("Icon Circle Click", () => {
  beforeEach(() => {
    document.body.innerHTML = `
      <div class="flip-card">
        <div class="icon-circle"></div>
      </div>
    `;

    document.querySelectorAll(".icon-circle").forEach((icon) => {
      icon.addEventListener("click", () => {
        const flipCard = icon.closest(".flip-card");
        if (flipCard) {
          flipCard.classList.toggle("active");
        }
      });
    });
  });

  it("should toggle the active class on the flip-card when icon-circle is clicked", () => {
    const icon = document.querySelector(".icon-circle") as HTMLElement;
    const flipCard = icon.closest(".flip-card") as HTMLElement;

    fireEvent.click(icon);

    expect(flipCard).toHaveClass("active");

    fireEvent.click(icon);

    expect(flipCard).not.toHaveClass("active");
  });
});
