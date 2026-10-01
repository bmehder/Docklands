const button = document.querySelector("[data-back-to-top]");

if (button) {
  const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");

  const updateVisibility = () => {
    const pageNeedsControl =
      document.documentElement.scrollHeight > window.innerHeight * 1.5;
    button.hidden = !pageNeedsControl || window.scrollY < window.innerHeight;
  };

  button.addEventListener("click", () => {
    window.scrollTo({
      top: 0,
      behavior: reducedMotion.matches ? "auto" : "smooth",
    });
  });

  window.addEventListener("scroll", updateVisibility, { passive: true });
  window.addEventListener("resize", updateVisibility);
  updateVisibility();
}
