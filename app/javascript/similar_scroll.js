document.addEventListener("DOMContentLoaded", () => {
  const container = document.querySelector("[data-scroll-container]");
  if (!container) return;

  const item = container.querySelector(".similar-scroll__item");
  if (!item) return;

  const scrollAmount = item.offsetWidth + 24; // largura + gap

  document
    .querySelector(".scroll-btn--left")
    ?.addEventListener("click", () => {
      container.scrollBy({ left: -scrollAmount, behavior: "smooth" });
    });

  document
    .querySelector(".scroll-btn--right")
    ?.addEventListener("click", () => {
      container.scrollBy({ left: scrollAmount, behavior: "smooth" });
    });
});
