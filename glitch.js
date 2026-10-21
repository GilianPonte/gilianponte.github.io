
document.addEventListener("DOMContentLoaded", () => {
  const probability = 0.005; // 1.5% per letter per update
  const interval = 150;      // milliseconds
  const symbols = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%&";

  // Apply only to regular paragraphs and headings
  const elements = document.querySelectorAll(
    "main p, main h1, main h2"
  );

  const textNodes = [];

  elements.forEach(element => {
    const walker = document.createTreeWalker(
      element,
      NodeFilter.SHOW_TEXT
    );

    while (walker.nextNode()) {
      const node = walker.currentNode;

      // Avoid changing clickable link text
      if (node.parentElement.closest("a, script, style")) continue;

      textNodes.push({
        node,
        original: node.nodeValue
      });
    }
  });

  let timer;

  function startGlitch() {
    timer = setInterval(() => {
      textNodes.forEach(({ node, original }) => {
        node.nodeValue = Array.from(original, character => {
          if (!/[a-zA-Z0-9]/.test(character)) return character;

          return Math.random() < probability
            ? symbols[Math.floor(Math.random() * symbols.length)]
            : character;
        }).join("");
      });
    }, interval);
  }

  if (!window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
    startGlitch();
  }
});
