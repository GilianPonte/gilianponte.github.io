
(() => {
  "use strict";

  const root = document.getElementById("full-turn-tunnel");
  if (!root || root.dataset.ready === "1") return;
  root.dataset.ready = "1";

  const canvas = root.querySelector("canvas");
  const ctx = canvas?.getContext("2d");
  const loc = root.querySelector(".ftt-location");
  const lang = root.querySelector(".ftt-language");
  const skip = root.querySelector(".ftt-skip");

  if (!ctx || !loc || !lang || !skip) {
    root.remove();
    return;
  }

  if (matchMedia("(prefers-reduced-motion: reduce)").matches) {
    root.remove();
    return;
  }

  // LANGUAGE
  lang.textContent =
    "LANGUAGE: " + (navigator.language || "UNKNOWN");

  // APPROXIMATE LOCATION
  // Uses an external IP location service.
  loc.textContent = "LOCATION: ESTIMATING...";

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 3500);

  fetch("https://ipwho.is/", {
    signal: controller.signal
  })
    .then(response => {
      if (!response.ok) throw new Error("Unavailable");
      return response.json();
    })
    .then(data => {
      if (!data.success) throw new Error("Unavailable");

      const place = [
        data.city,
        data.region,
        data.country
      ].filter(Boolean).join(", ");

      loc.textContent = "APPROXIMATE LOCATION: " +
        (place || "UNKNOWN");
    })
    .catch(() => {
      loc.textContent = "APPROXIMATE LOCATION: UNKNOWN";
    })
    .finally(() => clearTimeout(timeout));

  // TUNNEL SETTINGS
  const TAU = Math.PI * 2;
  const SIDES = 24;
  const DEPTH = 28;
  const SPEED = 30;
  const DURATION = 10800;

  let raf = 0;
  let started = null;
  let finished = false;

  function finish() {
    if (finished) return;
    finished = true;

    cancelAnimationFrame(raf);
    window.removeEventListener("keydown", onKeyDown);

    // Reveal the actual homepage
    root.remove();
  }

  function onKeyDown(event) {
    if (event.key === "Escape") finish();
  }

  skip.addEventListener("click", finish);
  window.addEventListener("keydown", onKeyDown);

  // LEFT AND RIGHT TURNS
  function pathX(s) {
    return (
      Math.sin(s * 0.11) * 2.7 +
      Math.sin(s * 0.045 + 1.6) * 1.4
    );
  }

  // UP AND DOWN TURNS
  function pathY(s) {
    return (
      Math.cos(s * 0.09 + 0.7) * 2.2 +
      Math.sin(s * 0.038 + 2.3) * 1.2
    );
  }

  function draw(now) {
    if (finished || !root.isConnected) return;

    if (started === null) started = now;

    const elapsed = now - started;
    const t = elapsed / 1000;

    const w = root.clientWidth;
    const h = root.clientHeight;

    if (!w || !h) {
      raf = requestAnimationFrame(draw);
      return;
    }

    const dpr = Math.min(devicePixelRatio || 1, 2);

    if (
      canvas.width !== Math.round(w * dpr) ||
      canvas.height !== Math.round(h * dpr)
    ) {
      canvas.width = Math.round(w * dpr);
      canvas.height = Math.round(h * dpr);
    }

    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    ctx.fillStyle = "#000";
    ctx.fillRect(0, 0, w, h);

    const cx = w / 2;
    const cy = h / 2;
    const minSide = Math.min(w, h);
    const radius = minSide * 0.52;
    const focal = 3.9;
    const travel = t * SPEED;
    const roll = Math.sin(t * 0.9) * 0.025;

    function curveX(z) {
      return (
        pathX(travel + z) - pathX(travel)
      ) * minSide * 0.22;
    }

    function curveY(z) {
      return (
        pathY(travel + z) - pathY(travel)
      ) * minSide * 0.18;
    }

    function project(z, angle) {
      const p = focal / (z + focal);
      const r = radius * p * 3.25;

      return [
        cx + curveX(z) * p * 2.15 + Math.cos(angle) * r,
        cy + curveY(z) * p * 2.15 +
          Math.sin(angle) * r * 0.86
      ];
    }

    // LONGITUDINAL TUNNEL LINES
    for (let side = 0; side < SIDES; side++) {
      const angle = side * TAU / SIDES + roll;

      ctx.beginPath();

      for (let step = 0; step <= 58; step++) {
        const z = DEPTH - step * (DEPTH - 0.18) / 58;
        const p = project(z, angle);

        if (step === 0) ctx.moveTo(p[0], p[1]);
        else ctx.lineTo(p[0], p[1]);
      }

      ctx.strokeStyle = "rgba(0,255,0,0.70)";
      ctx.lineWidth = 1.2;
      ctx.stroke();
    }

    // RINGS MOVING TOWARD THE VIEWER
    for (let ring = 0; ring < 50; ring++) {
      const z =
        0.18 +
        ((ring * 0.55 - travel) % DEPTH + DEPTH) % DEPTH;

      const opacity = 0.18 + 0.82 * (1 - z / DEPTH);

      ctx.strokeStyle = `rgba(0,255,0,${opacity})`;
      ctx.lineWidth = z < 3 ? 1.9 : 1;
      ctx.beginPath();

      for (let step = 0; step <= 84; step++) {
        const angle = step * TAU / 84 + roll;
        const p = project(z, angle);

        if (step === 0) ctx.moveTo(p[0], p[1]);
        else ctx.lineTo(p[0], p[1]);
      }

      ctx.stroke();
    }

    // PRIVACY MESSAGES FLYING THROUGH THE TUNNEL
    const messages = [
      {
        element: loc,
        delay: 0.7,
        x: -0.28,
        y: -0.22,
        tilt: -8
      },
      {
        element: lang,
        delay: 4.6,
        x: 0.27,
        y: 0.22,
        tilt: 7
      }
    ];

    messages.forEach(message => {
      const progress = (t - message.delay) / 4.8;

      if (progress < 0 || progress > 1) {
        message.element.style.opacity = "0";
        return;
      }

      const ease =
        progress * progress * (3 - 2 * progress);

      const movement = 0.1 + 1.75 * ease;

      const x =
        cx + message.x * w * movement +
        curveX(6) * 0.26;

      const y =
        cy + message.y * h * movement +
        curveY(6) * 0.26;

      const scale = 0.32 + 1.52 * ease;

      message.element.style.transform =
        `translate(-50%,-50%) ` +
        `translate3d(${x}px,${y}px,0) ` +
        `rotate(${message.tilt * ease}deg) ` +
        `scale(${scale})`;

      message.element.style.opacity = String(
        Math.max(
          0,
          Math.min(1, progress * 5, (1 - progress) * 4)
        )
      );
    });

    if (elapsed >= DURATION) {
      finish();
    } else {
      raf = requestAnimationFrame(draw);
    }
  }

  raf = requestAnimationFrame(draw);
})();
