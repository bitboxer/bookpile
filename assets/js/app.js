import "../css/app.css";
import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
});
topbar.config({
  barColors: { 0: "#b07a1e" },
  shadowColor: "rgba(0, 0, 0, .3)",
});
window.addEventListener("phx:page-loading-start", () => topbar.show());
window.addEventListener("phx:page-loading-stop", () => topbar.hide());
liveSocket.connect();
window.liveSocket = liveSocket;

// ─── Region picker ───────────────────────────────────────────────────────────

function buildLocations() {
  const regions = window.BOOKPILE_REGIONS;
  if (!regions) return [];
  return Object.entries(regions).flatMap(([country, c]) =>
    Object.keys(c.cities).map((city) => ({
      country,
      city,
      flag: c.flag,
    })),
  );
}

function renderLocationList(query) {
  const locations = buildLocations();
  const selectedCountry = window.BOOKPILE_COUNTRY;
  const selectedCity = window.BOOKPILE_CITY;
  const q = (query || "").trim().toLowerCase();
  const filtered = q
    ? locations.filter(
        (loc) =>
          loc.city.toLowerCase().includes(q) ||
          loc.country.toLowerCase().includes(q),
      )
    : locations;

  const list = document.getElementById("region-list");
  if (!list) return;

  if (filtered.length === 0) {
    list.innerHTML = `<div class="popover-empty">No locations match — try a country name.</div>`;
    return;
  }

  list.innerHTML = filtered
    .map((loc) => {
      const sel = loc.city === selectedCity && loc.country === selectedCountry;
      return `<div class="popover-location-row${sel ? " selected" : ""}"
        data-country="${loc.country}" data-city="${loc.city}" role="option"
        aria-selected="${sel}">
      <div>
        <div class="loc-city">${loc.city}</div>
        <div class="loc-country">${loc.country}</div>
      </div>
      <span class="loc-flag">${loc.flag}</span>
    </div>`;
    })
    .join("");

  list.querySelectorAll(".popover-location-row").forEach((row) => {
    row.addEventListener("click", () => {
      closePopover();
      const params = new URLSearchParams({
        country: row.dataset.country,
        city: row.dataset.city,
      });
      window.location.href = `/b/${window.BOOKPILE_ISBN}?${params}`;
    });
  });
}

function openPopover() {
  const popover = document.getElementById("region-popover");
  const search = document.getElementById("region-search");
  if (!popover) return;
  popover.style.display = "block";
  renderLocationList("");
  setTimeout(() => search?.focus(), 0);
}

function closePopover() {
  const popover = document.getElementById("region-popover");
  if (popover) popover.style.display = "none";
  const search = document.getElementById("region-search");
  if (search) search.value = "";
}

function setupRegionPicker() {
  const btn = document.getElementById("region-picker-btn");
  if (!btn) return;

  btn.addEventListener("click", (e) => {
    e.stopPropagation();
    const popover = document.getElementById("region-popover");
    if (popover?.style.display === "none" || !popover?.style.display) {
      openPopover();
    } else {
      closePopover();
    }
  });

  const search = document.getElementById("region-search");
  search?.addEventListener("input", (e) => {
    renderLocationList(e.target.value);
  });
  search?.addEventListener("keydown", (e) => {
    if (e.key === "Escape") closePopover();
  });

  document.addEventListener("click", (e) => {
    const wrapper = document.getElementById("region-picker-wrapper");
    if (wrapper && !wrapper.contains(e.target)) closePopover();
  });
}

// ─── Share button ────────────────────────────────────────────────────────────

function setupShareButton() {
  const btn = document.getElementById("share-btn");
  if (!btn) return;

  btn.addEventListener("click", () => {
    const isbn = btn.dataset.isbn;
    const url = `https://bookpile.org/b/${isbn}`;
    const original = btn.textContent;

    const done = (label = "✓ Link copied") => {
      btn.textContent = label;
      btn.classList.add("copied");
      setTimeout(() => {
        btn.textContent = original;
        btn.classList.remove("copied");
      }, 1500);
    };

    const copyFallback = () =>
      navigator.clipboard?.writeText(url).then(() => done()).catch(() => {});

    if (navigator.share) {
      navigator
        .share({ title: document.title, url })
        .then(() => done("✓ Shared"))
        .catch((err) => { if (err.name !== "AbortError") copyFallback(); });
    } else {
      copyFallback();
    }
  });
}


// ─── Cover fallback ──────────────────────────────────────────────────────────

function setupCoverFallback() {
  const img = document.getElementById("book-cover-img");
  if (!img) return;

  const showFallback = () => {
    img.style.display = "none";
    const fallback = document.getElementById("cover-fallback");
    if (fallback) fallback.style.display = "flex";
  };

  img.addEventListener("error", showFallback);

  // Also detect 1×1 pixel placeholder images (Open Library returns these for missing covers)
  img.addEventListener("load", () => {
    if (img.naturalWidth <= 1 && img.naturalHeight <= 1) showFallback();
  });
}

// ─── Description clamp ───────────────────────────────────────────────────────

function setupDescriptionClamp() {
  const el = document.getElementById("book-description");
  const btn = document.getElementById("show-more-btn");
  if (!el || !btn) return;

  el.classList.add("book-description--clamped");
  if (el.scrollHeight > el.clientHeight) {
    btn.style.display = "block";
    btn.addEventListener("click", () => {
      const expanded = !el.classList.contains("book-description--clamped");
      el.classList.toggle("book-description--clamped");
      btn.textContent = expanded ? "Show more…" : "Show less…";
    });
  } else {
    el.classList.remove("book-description--clamped");
  }
}

// ─── Init ────────────────────────────────────────────────────────────────────

document.addEventListener("DOMContentLoaded", () => {
  if (window.BOOKPILE_REGIONS) {
    setupRegionPicker();
    setupCoverFallback();
  }

  setupShareButton();
  setupDescriptionClamp();
});
