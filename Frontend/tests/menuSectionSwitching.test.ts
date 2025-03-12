import { fireEvent } from '@testing-library/dom';
import '@testing-library/jest-dom';
import { updateCharts } from '../src/utils/charts.ts';

jest.mock('../src/utils/charts.ts');

describe('Menu and Section Switching', () => {
  beforeEach(() => {
    document.body.innerHTML = `
      <div class="menu">
        <button class="menu__item active" data-section="home"></button>
        <button class="menu__item" data-section="participants"></button>
        <button class="menu__item" data-section="voting"></button>
        <button class="menu__item" data-section="results"></button>
        <div class="menu__border"></div>
      </div>
      <section id="home"></section>
      <section id="participants"></section>
      <section id="voting"></section>
      <section id="results"></section>
    `;

    const body = document.body;
    const bgColorsBody = ["#ffb457", "#ff96bd", "#9999fb", "#ffe797"];
    const menu = body.querySelector(".menu") as HTMLElement;
    const menuItems = menu.querySelectorAll(".menu__item");
    const menuBorder = menu.querySelector(".menu__border");
    let activeItem = menu.querySelector(".active");
    const sections = document.querySelectorAll("section");

    function clickItem(item: HTMLElement, index: number) {
      menu.style.removeProperty("--timeOut");

      if (activeItem === item) return;

      if (activeItem) {
        activeItem.classList.remove("active");
      }

      item.classList.add("active");
      body.style.backgroundColor = bgColorsBody[index];
      activeItem = item;

      if (activeItem) {
        offsetMenuBorder(activeItem as HTMLElement, menuBorder as HTMLElement);
      }

      // Show the corresponding section and hide others
      const sectionId = item.getAttribute("data-section");
      if (sectionId) {
        sections.forEach((section) => {
          section.style.display = section.id === sectionId ? "block" : "none";
        });

        if (sectionId === "results") {
          updateCharts();
        }
      }
    }

    function offsetMenuBorder(element: HTMLElement, menuBorder: HTMLElement) {
      const offsetActiveItem = element.getBoundingClientRect();
      const left =
        Math.floor(
          offsetActiveItem.left -
            menu.offsetLeft -
            (menuBorder.offsetWidth - offsetActiveItem.width) / 2
        ) + "px";
      menuBorder.style.transform = `translate3d(${left}, 0 , 0)`;
    }

    if (activeItem) {
      offsetMenuBorder(activeItem as HTMLElement, menuBorder as HTMLElement);
    }

    menuItems.forEach((item, index) => {
      item.addEventListener("click", (e) => {
        e.preventDefault(); // Prevent default anchor jump
        clickItem(item as HTMLElement, index);
      });
    });

    window.addEventListener("resize", () => {
      offsetMenuBorder(activeItem as HTMLElement, menuBorder as HTMLElement);
      menu.style.setProperty("--timeOut", "none");
    });

    // Hide all sections initially except the first one
    sections.forEach((section, index) => {
      section.style.display = index === 0 ? "block" : "none";
    });
  });

  it('should switch sections and update background color on menu item click', () => {
    const menuItems = document.querySelectorAll('.menu__item');
    const sections = document.querySelectorAll('section');

    fireEvent.click(menuItems[1]);
    expect(menuItems[1]).toHaveClass('active');
    expect(sections[1]).toBeVisible();
    expect(sections[0]).not.toBeVisible();

    fireEvent.click(menuItems[3]);
    expect(menuItems[3]).toHaveClass('active');
    expect(sections[3]).toBeVisible();
    expect(sections[1]).not.toBeVisible();
    expect(updateCharts).toHaveBeenCalled();
  });
});