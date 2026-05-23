import "../css/app.css"
import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})
topbar.config({barColors: {0: "#b07a1e"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", () => topbar.show())
window.addEventListener("phx:page-loading-stop", () => topbar.hide())
liveSocket.connect()
window.liveSocket = liveSocket

// ─── URL builder ────────────────────────────────────────────────────────────

const URL_PATTERNS = {
  'genialokal.de':          (isbn) => `https://www.genialokal.de/Suche/?q=${isbn}`,
  'hugendubel.de':          (isbn) => `https://www.hugendubel.de/de/search?searchTerm=${isbn}`,
  'thalia.de':              (isbn) => `https://www.thalia.de/suche?sq=${isbn}`,
  'buchhandlung-walther-koenig.de': (isbn) => `https://www.buchhandlung-walther-koenig.de/search?q=${isbn}`,
  'bookshop.org/de':        (isbn) => `https://bookshop.org/de/books?keywords=${isbn}`,
  'amazon.de':              (isbn) => `https://www.amazon.de/dp/${isbn}`,
  'voebb.de':               (isbn) => `https://voebb.de/search?q=${isbn}`,
  'staatsbibliothek-berlin.de': (isbn) => `https://stabikat.de/DB=1/CMD?ACT=SRCHA&IKT=1007&TRM=${isbn}`,
  'worldcat.org':           (isbn) => `https://search.worldcat.org/search?q=${isbn}`,
  'openlibrary.org':        (isbn) => `https://openlibrary.org/isbn/${isbn}`,
  'muenchner-stadtbibliothek.de': (isbn) => `https://www.muenchner-stadtbibliothek.de/katalog?q=${isbn}`,
  'bsb-muenchen.de':        (isbn) => `https://opacplus.bsb-muenchen.de/search?isbn=${isbn}`,
  'lehmkuhl.net':           (isbn) => `https://www.lehmkuhl.net/suche?q=${isbn}`,
  'buecherhallen.de':       (isbn) => `https://www.buecherhallen.de/recherche.html?q=${isbn}`,
  'sub.uni-hamburg.de':     (isbn) => `https://katalog.sub.uni-hamburg.de/Search/Results?lookfor=${isbn}&type=ISN`,
  'codobuch.de':            (isbn) => `https://www.codobuch.de/suche?q=${isbn}`,
  'bookshop.org':           (isbn) => `https://bookshop.org/books?keywords=${isbn}`,
  'strandbooks.com':        (isbn) => `https://www.strandbooks.com/search?type=product&q=${isbn}`,
  'mcnallyjackson.com':     (isbn) => `https://www.mcnallyjackson.com/search?type=product&q=${isbn}`,
  'powells.com':            (isbn) => `https://www.powells.com/searchresults?keyword=${isbn}`,
  'barnesandnoble.com':     (isbn) => `https://www.barnesandnoble.com/s/${isbn}`,
  'amazon.com':             (isbn) => `https://www.amazon.com/dp/${isbn}`,
  'nypl.org':               (isbn) => `https://catalog.nypl.org/search/?searchtype=i&query=${isbn}`,
  'bklynlibrary.org':       (isbn) => `https://www.bklynlibrary.org/research/search?search=${isbn}`,
  'citylights.com':         (isbn) => `https://www.citylights.com/search/?q=${isbn}`,
  'greenapplebooks.com':    (isbn) => `https://www.greenapplebooks.com/search?query=${isbn}`,
  'sfpl.org':               (isbn) => `https://sfpl.org/index.php?pg=2400002&lookfor=${isbn}&type=ISN`,
  'archive.org':            (isbn) => `https://archive.org/search?query=${isbn}`,
  'uk.bookshop.org':        (isbn) => `https://uk.bookshop.org/books?keywords=${isbn}`,
  'hive.co.uk':             (isbn) => `https://www.hive.co.uk/Search?Keywords=${isbn}`,
  'foyles.co.uk':           (isbn) => `https://www.foyles.co.uk/books/search?term=${isbn}`,
  'waterstones.com':        (isbn) => `https://www.waterstones.com/books/search/term/${isbn}`,
  'blackwells.co.uk':       (isbn) => `https://blackwells.co.uk/bookshop/search/?isbn=${isbn}`,
  'amazon.co.uk':           (isbn) => `https://www.amazon.co.uk/dp/${isbn}`,
  'bl.uk':                  (isbn) => `https://explore.bl.uk/primo_library/libweb/action/search.do?fn=search&vl(freeText0)=${isbn}`,
  'londonlibraries.gov.uk': (isbn) => `https://londonlibraries.gov.uk/search?q=${isbn}`,
  'placedeslibraires.fr':   (isbn) => `https://www.placedeslibraires.fr/livre/?q=${isbn}`,
  'galignani.fr':            (isbn) => `https://www.galignani.fr/search/?q=${isbn}`,
  'fnac.com':               (isbn) => `https://www.fnac.com/SearchResult/ResultList.aspx?SCat=0&sft=1&Search=${isbn}`,
  'cultura.com':            (isbn) => `https://www.cultura.com/catalogsearch/result/?q=${isbn}`,
  'decitre.fr':             (isbn) => `https://www.decitre.fr/recherche/resultat.aspx?q=${isbn}`,
  'amazon.fr':              (isbn) => `https://www.amazon.fr/dp/${isbn}`,
  'bnf.fr':                 (isbn) => `https://catalogue.bnf.fr/recherche-simple-isbn.do?query=${isbn}`,
  'bibliotheques.paris.fr': (isbn) => `https://bibliotheques.paris.fr/Default/search.aspx?SC_SEARCH=${isbn}`,
  'athenaeum.nl':           (isbn) => `https://www.athenaeum.nl/zoeken?q=${isbn}`,
  'libris.nl':              (isbn) => `https://www.libris.nl/search?q=${isbn}`,
  'abc.nl':                 (isbn) => `https://www.abc.nl/search?q=${isbn}`,
  'bol.com':                (isbn) => `https://www.bol.com/nl/rnwy/search?q=${isbn}`,
  'amazon.nl':              (isbn) => `https://www.amazon.nl/dp/${isbn}`,
  'oba.nl':                 (isbn) => `https://www.oba.nl/catalogus.html?q=${isbn}`,
  'kb.nl':                  (isbn) => `https://www.kb.nl/zoeken?q=${isbn}`,
};

function entryUrl(domain, isbn) {
  const fn = URL_PATTERNS[domain];
  return fn ? fn(isbn) : `https://${domain}`;
}

function shopGlyph(domain) {
  const root = (domain || '').replace(/^www\./, '').split('.')[0];
  return (root[0] || '?').toUpperCase();
}

const LIBRARY_ICON = `<svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="1.6">
  <path d="M3 9 L12 4 L21 9"/>
  <path d="M5 9 V19 M9 9 V19 M15 9 V19 M19 9 V19"/>
  <path d="M3 20 H21"/>
</svg>`;

function isMobile() {
  return window.innerWidth <= 720;
}

// ─── Listings renderer ───────────────────────────────────────────────────────

function renderListingRow(entry, kind, index, isbn) {
  const url = entryUrl(entry.domain, isbn);
  const actionLabel = kind === 'library' ? 'Search ↗' : `${entry.domain} ↗`;
  const iconContent = kind === 'library'
    ? LIBRARY_ICON
    : shopGlyph(entry.domain);
  const num = String(index + 1).padStart(2, '0');
  const bookTitle = document.querySelector('.book-title')?.textContent || 'this book';
  const ariaLabel = kind === 'library'
    ? `Search ${entry.name} for ${bookTitle}`
    : `Buy ${bookTitle} on ${entry.name}`;

  return `<a href="${url}" target="_blank" rel="noopener noreferrer"
      class="listing-row" aria-label="${ariaLabel}">
    <span class="listing-index">${num}</span>
    <span class="listing-icon">${iconContent}</span>
    <span class="listing-info">
      <span class="listing-name">${entry.name}</span>
      <span class="listing-note">${entry.note}</span>
      ${isMobile() ? `<span class="listing-action-mobile">${actionLabel}</span>` : ''}
    </span>
    <span class="listing-action">${actionLabel}</span>
  </a>`;
}

function renderListings(country, city) {
  const regions = window.BOOKPILE_REGIONS;
  const isbn = window.BOOKPILE_ISBN || '';
  if (!regions) return;

  const cityData = regions[country]?.cities?.[city] || {shops: [], libraries: []};
  const {shops, libraries} = cityData;

  const shopsList = document.getElementById('shops-list');
  const librariesList = document.getElementById('libraries-list');
  const shopsCount = document.getElementById('shops-count');
  const regionCityDisplay = document.getElementById('region-city-display');

  if (shopsList) shopsList.innerHTML = shops.map((s, i) => renderListingRow(s, 'shop', i, isbn)).join('');
  if (librariesList) librariesList.innerHTML = libraries.map((l, i) => renderListingRow(l, 'library', i, isbn)).join('');
  if (shopsCount) shopsCount.textContent = `${shops.length} places`;
  if (regionCityDisplay) regionCityDisplay.textContent = city;
}

// ─── State ───────────────────────────────────────────────────────────────────

let currentCountry = localStorage.getItem('bp_country') || 'Germany';
let currentCity = localStorage.getItem('bp_city') || 'Berlin';

function setLocation(country, city) {
  currentCountry = country;
  currentCity = city;
  localStorage.setItem('bp_country', country);
  localStorage.setItem('bp_city', city);

  // Update picker button text
  const pickerCity = document.getElementById('picker-city-text');
  const pickerCountry = document.getElementById('picker-country-text');
  if (pickerCity) pickerCity.textContent = city;
  if (pickerCountry) pickerCountry.textContent = country;

  // Dim and reload
  const listsArea = document.getElementById('lists-area');
  if (listsArea) {
    listsArea.classList.add('reloading');
    setTimeout(() => {
      renderListings(country, city);
      listsArea.classList.remove('reloading');
    }, 320);
  } else {
    renderListings(country, city);
  }
}

// ─── Region picker ───────────────────────────────────────────────────────────

function buildLocations() {
  const regions = window.BOOKPILE_REGIONS;
  if (!regions) return [];
  return Object.entries(regions).flatMap(([country, c]) =>
    Object.keys(c.cities).map(city => ({
      country, city, flag: c.flag,
      label: `${city}, ${country}`,
    }))
  );
}

function renderLocationList(query, selectedCountry, selectedCity) {
  const locations = buildLocations();
  const q = (query || '').trim().toLowerCase();
  const filtered = q
    ? locations.filter(loc =>
        loc.city.toLowerCase().includes(q) ||
        loc.country.toLowerCase().includes(q))
    : locations;

  const list = document.getElementById('region-list');
  if (!list) return;

  if (filtered.length === 0) {
    list.innerHTML = `<div class="popover-empty">No locations match — try a country name.</div>`;
    return;
  }

  list.innerHTML = filtered.map(loc => {
    const sel = loc.city === selectedCity && loc.country === selectedCountry;
    return `<div class="popover-location-row${sel ? ' selected' : ''}"
        data-country="${loc.country}" data-city="${loc.city}" role="option"
        aria-selected="${sel}">
      <div>
        <div class="loc-city">${loc.city}</div>
        <div class="loc-country">${loc.country}</div>
      </div>
      <span class="loc-flag">${loc.flag}</span>
    </div>`;
  }).join('');

  list.querySelectorAll('.popover-location-row').forEach(row => {
    row.addEventListener('click', () => {
      const country = row.dataset.country;
      const city = row.dataset.city;
      closePopover();
      setLocation(country, city);
    });
  });
}

function openPopover() {
  const popover = document.getElementById('region-popover');
  const search = document.getElementById('region-search');
  if (!popover) return;
  popover.style.display = 'block';
  renderLocationList('', currentCountry, currentCity);
  setTimeout(() => search?.focus(), 0);
}

function closePopover() {
  const popover = document.getElementById('region-popover');
  if (popover) popover.style.display = 'none';
  const search = document.getElementById('region-search');
  if (search) search.value = '';
}

function setupRegionPicker() {
  const btn = document.getElementById('region-picker-btn');
  if (!btn) return;

  btn.addEventListener('click', (e) => {
    e.stopPropagation();
    const popover = document.getElementById('region-popover');
    if (popover?.style.display === 'none' || !popover?.style.display) {
      openPopover();
    } else {
      closePopover();
    }
  });

  const search = document.getElementById('region-search');
  search?.addEventListener('input', (e) => {
    renderLocationList(e.target.value, currentCountry, currentCity);
  });
  search?.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closePopover();
  });

  document.addEventListener('click', (e) => {
    const wrapper = document.getElementById('region-picker-wrapper');
    if (wrapper && !wrapper.contains(e.target)) closePopover();
  });
}

// ─── Share button ────────────────────────────────────────────────────────────

function setupShareButton() {
  const btn = document.getElementById('share-btn');
  if (!btn) return;

  btn.addEventListener('click', () => {
    const isbn = btn.dataset.isbn;
    const url = `bookpile.org/b/${isbn}`;
    const original = btn.textContent;

    const done = () => {
      btn.textContent = '✓ Link copied';
      btn.classList.add('copied');
      setTimeout(() => {
        btn.textContent = original;
        btn.classList.remove('copied');
      }, 1500);
    };

    if (navigator.clipboard) {
      navigator.clipboard.writeText(url).then(done).catch(() => fallbackCopy(url, done));
    } else {
      fallbackCopy(url, done);
    }
  });
}

function fallbackCopy(text, cb) {
  const ta = document.createElement('textarea');
  ta.value = text;
  ta.style.cssText = 'position:fixed;top:-9999px;left:-9999px';
  document.body.appendChild(ta);
  ta.select();
  try { document.execCommand('copy'); cb(); } catch (e) {}
  document.body.removeChild(ta);
}

// ─── Cover fallback ──────────────────────────────────────────────────────────

function setupCoverFallback() {
  const img = document.getElementById('book-cover-img');
  if (!img) return;

  const showFallback = () => {
    img.style.display = 'none';
    const fallback = document.getElementById('cover-fallback');
    if (fallback) fallback.style.display = 'flex';
  };

  img.addEventListener('error', showFallback);

  // Also detect 1×1 pixel placeholder images (Open Library returns these for missing covers)
  img.addEventListener('load', () => {
    if (img.naturalWidth <= 1 && img.naturalHeight <= 1) showFallback();
  });
}

// ─── Init ────────────────────────────────────────────────────────────────────

document.addEventListener('DOMContentLoaded', () => {
  if (window.BOOKPILE_REGIONS) {
    // Restore saved location
    const savedCountry = localStorage.getItem('bp_country');
    const savedCity = localStorage.getItem('bp_city');
    const regions = window.BOOKPILE_REGIONS;

    if (savedCountry && savedCity && regions[savedCountry]?.cities?.[savedCity]) {
      currentCountry = savedCountry;
      currentCity = savedCity;
    }

    // Sync picker button to current location
    const pickerCity = document.getElementById('picker-city-text');
    const pickerCountry = document.getElementById('picker-country-text');
    if (pickerCity) pickerCity.textContent = currentCity;
    if (pickerCountry) pickerCountry.textContent = currentCountry;

    renderListings(currentCountry, currentCity);
    setupRegionPicker();
    setupCoverFallback();
  }

  setupShareButton();
});
