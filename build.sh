#!/usr/bin/env bash
set -e

DOMAIN="https://best-antarctica-expedition-cruises.com"
ROOT="$(cd "$(dirname "$0")" && pwd)"

HEADER="$ROOT/components/header.html"
FOOTER="$ROOT/components/footer.html"
TMP_HEADER="$ROOT/.tmp_header.html"
TMP_FOOTER="$ROOT/.tmp_footer.html"
TMP_CONTENT="$ROOT/.tmp_content.html"

# ── JSON-LD schemas for index page ──────────────────────────────
SCHEMA_ARTICLE=$(cat <<'JSONLD'
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "Best Antarctica Expedition Cruises 2026: Top 10 Operators Ranked",
  "description": "Independent ranking of the best Antarctica expedition cruise operators for 2026. Compare ships, shore time, activities, and prices to find the right polar expedition for you.",
  "datePublished": "2026-01-01",
  "dateModified": "2026-06-01",
  "publisher": {
    "@type": "Organization",
    "name": "Best Antarctica Expedition Cruises",
    "url": "https://best-antarctica-expedition-cruises.com"
  },
  "author": {
    "@type": "Organization",
    "name": "Antarctica Expedition Experts Editorial Team"
  }
}
</script>
JSONLD
)

SCHEMA_ORG=$(cat <<'JSONLD'
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "Best Antarctica Expedition Cruises",
  "url": "https://best-antarctica-expedition-cruises.com"
}
</script>
JSONLD
)

SCHEMA_ITEMLIST=$(cat <<'JSONLD'
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "ItemList",
  "name": "Best Antarctica Expedition Cruise Operators 2026",
  "itemListElement": [
    {"@type":"ListItem","position":1,"name":"Poseidon Expeditions","url":"https://poseidonexpeditions.com"},
    {"@type":"ListItem","position":2,"name":"Aurora Expeditions","url":"https://www.auroraexpeditions.com.au"},
    {"@type":"ListItem","position":3,"name":"Quark Expeditions","url":"https://www.quarkexpeditions.com"},
    {"@type":"ListItem","position":4,"name":"Oceanwide Expeditions","url":"https://www.oceanwide-expeditions.com"},
    {"@type":"ListItem","position":5,"name":"HX Expeditions","url":"https://www.hxexpeditions.com"},
    {"@type":"ListItem","position":6,"name":"Lindblad Expeditions / National Geographic","url":"https://www.expeditions.com"},
    {"@type":"ListItem","position":7,"name":"Antarctica21","url":"https://www.antarctica21.com"},
    {"@type":"ListItem","position":8,"name":"Ponant","url":"https://en.ponant.com"},
    {"@type":"ListItem","position":9,"name":"Albatros Expeditions","url":"https://www.albatrosexpeditions.com"},
    {"@type":"ListItem","position":10,"name":"Heritage Expeditions","url":"https://www.heritage-expeditions.com"}
  ]
}
</script>
JSONLD
)

SCHEMA_BREADCRUMB=$(cat <<'JSONLD'
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type":"ListItem","position":1,"name":"Home","item":"https://best-antarctica-expedition-cruises.com/"}
  ]
}
</script>
JSONLD
)

SCHEMA_FAQ=$(cat <<'JSONLD'
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What is the IAATO 100-passenger landing rule?",
      "acceptedAnswer": {"@type":"Answer","text":"IAATO limits the number of passengers who can be ashore at any single Antarctic landing site simultaneously to 100 people. Ships carrying fewer than 200 passengers can typically land their full complement in one or two Zodiac rotations. Ships with 200-500 passengers must rotate groups, significantly reducing effective shore time per passenger."}
    },
    {
      "@type": "Question",
      "name": "What is the difference between an expedition cruise and a scenic cruise in Antarctica?",
      "acceptedAnswer": {"@type":"Answer","text":"An expedition cruise operates ships carrying fewer than 500 passengers and provides Zodiac landings at Antarctic shore sites. A scenic cruise operates large ships (500+ passengers) that sail through Antarctic waters but are prohibited by IAATO from landing any passengers ashore."}
    },
    {
      "@type": "Question",
      "name": "Should I choose Fly the Drake or sail the Drake Passage?",
      "acceptedAnswer": {"@type":"Answer","text":"The Drake Passage takes about 2 days to cross each direction. Fly the Drake itineraries fly passengers to King George Island, saving approximately 4 days total. Choose Fly the Drake if seasick-prone, time-constrained, or want to maximise Antarctic days. Operators: Quark Expeditions, Lindblad Expeditions, Antarctica21."}
    },
    {
      "@type": "Question",
      "name": "How many days does an Antarctica expedition cruise take?",
      "acceptedAnswer": {"@type":"Answer","text":"Classic Peninsula Cruise: 10-12 days. Fly the Drake: 8-9 days. Polar Circle Crossing: 14+ days. South Georgia and Falklands extension: 17-25 days."}
    },
    {
      "@type": "Question",
      "name": "What activities are available on an Antarctica expedition cruise?",
      "acceptedAnswer": {"@type":"Answer","text":"All operators offer Zodiac landings and cruising. Optional add-ons include sea kayaking (Poseidon, Aurora, Quark, Lindblad), overnight camping (Poseidon, Aurora, Quark), helicopter excursions (Quark Ultramarine), SCUBA diving (Aurora), ROV footage (Lindblad), and polar plunge."}
    },
    {
      "@type": "Question",
      "name": "What is the best time of year for an Antarctica expedition cruise?",
      "acceptedAnswer": {"@type":"Answer","text":"The expedition season runs November through March. December-January is peak season with maximum wildlife activity and 24-hour daylight. November offers iceberg scenery and fewer crowds. February-March offers peak whale activity and open ice for Polar Circle crossings."}
    },
    {
      "@type": "Question",
      "name": "Is sea kayaking available on Antarctica cruises?",
      "acceptedAnswer": {"@type":"Answer","text":"Yes, sea kayaking among Antarctic icebergs is offered as an optional add-on by Poseidon Expeditions, Aurora Expeditions, Quark Expeditions, Lindblad Expeditions, and Antarctica21. No prior experience required. Subject to weather conditions."}
    },
    {
      "@type": "Question",
      "name": "What is the guide-to-guest ratio and why does it matter?",
      "acceptedAnswer": {"@type":"Answer","text":"The guide-to-guest ratio describes how many expedition staff (naturalists, scientists) are aboard per passenger. 1:10 is good; 1:5 is excellent. Lindblad leads with 20+ National Geographic naturalists on 126-148 passenger vessels (approximately 1:6-1:7). Higher ratios mean better wildlife interpretation and smaller guided groups ashore."}
    },
    {
      "@type": "Question",
      "name": "Can I camp overnight in Antarctica?",
      "acceptedAnswer": {"@type":"Answer","text":"Yes, overnight camping in Antarctica is offered as an optional add-on by Poseidon Expeditions, Aurora Expeditions, and Quark Expeditions. Participants sleep in bivy bags on the Antarctic ice under 24-hour austral summer light. Must be booked in advance; capacity is strictly limited."}
    },
    {
      "@type": "Question",
      "name": "How far in advance should I book an Antarctica expedition cruise?",
      "acceptedAnswer": {"@type":"Answer","text":"For December-January peak season, book 12-18 months in advance. November and February-March voyages can often be booked 6-9 months out. Last-minute discounts occasionally exist for shoulder-season departures but should not be relied upon for primary planning."}
    }
  ]
}
</script>
JSONLD
)

# ── build_page function ──────────────────────────────────────────
# Args: $1=OUT_PATH $2=TITLE $3=DESC $4=CANONICAL $5=CONTENT_FILE
#       $6=BASE $7=ACTIVE_NAV $8=EXTRA_SCHEMA
build_page() {
  local OUT="$1"
  local TITLE="$2"
  local DESC="$3"
  local CANONICAL="$4"
  local CONTENT="$5"
  local BASE="$6"
  local ACTIVE_NAV="$7"
  local EXTRA_SCHEMA="$8"
  local OUT_DIR
  OUT_DIR="$(dirname "$OUT")"
  mkdir -p "$OUT_DIR"

  # Process header: inject active class + convert paths
  local ROOT_HREF
  if [ -z "$BASE" ]; then ROOT_HREF="./"; else ROOT_HREF="${BASE}"; fi

  sed \
    -e "s|href=\"$ACTIVE_NAV\"|href=\"$ACTIVE_NAV\" class=\"active\"|g" \
    -e "s|href=\"/\"|href=\"${ROOT_HREF}\"|g" \
    -e "s|href=\"/\([^\"]*\)\"|href=\"${BASE}\1\"|g" \
    -e "s|src=\"/\([^\"]*\)\"|src=\"${BASE}\1\"|g" \
    "$HEADER" > "$TMP_HEADER"

  # Process footer: convert paths
  sed \
    -e "s|href=\"/\"|href=\"${ROOT_HREF}\"|g" \
    -e "s|href=\"/\([^\"]*\)\"|href=\"${BASE}\1\"|g" \
    -e "s|src=\"/\([^\"]*\)\"|src=\"${BASE}\1\"|g" \
    "$FOOTER" > "$TMP_FOOTER"

  # Process content: convert paths
  sed \
    -e "s|href=\"/\"|href=\"${ROOT_HREF}\"|g" \
    -e "s|href=\"/\([^\"]*\)\"|href=\"${BASE}\1\"|g" \
    -e "s|src=\"/\([^\"]*\)\"|src=\"${BASE}\1\"|g" \
    "$CONTENT" > "$TMP_CONTENT"

  {
    cat <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${TITLE}</title>
  <meta name="description" content="${DESC}">
  <link rel="canonical" href="${CANONICAL}">
  <meta property="og:type" content="article">
  <meta property="og:title" content="${TITLE}">
  <meta property="og:description" content="${DESC}">
  <meta property="og:url" content="${CANONICAL}">
  <link rel="icon" href="${BASE}favicon.svg" type="image/svg+xml">
  <link rel="stylesheet" href="${BASE}css/global.css">
  <link rel="stylesheet" href="${BASE}css/main.css">
HTML
    echo "$EXTRA_SCHEMA"
    cat <<HTML
</head>
<body>
HTML
    cat "$TMP_HEADER"
    cat "$TMP_CONTENT"
    cat "$TMP_FOOTER"
    cat <<HTML
<script src="${BASE}js/nav.js"></script>
</body>
</html>
HTML
  } > "$OUT"
}

echo "Building index.html..."
build_page \
  "$ROOT/index.html" \
  "Best Antarctica Expedition Cruises 2026: Top 10 Operators Ranked" \
  "Independent ranking of the best Antarctica expedition cruise operators for 2026. Compare ships, shore time, activities, and prices to find the right polar expedition for you." \
  "${DOMAIN}/" \
  "$ROOT/content/main.html" \
  "" \
  "__none__" \
  "${SCHEMA_ARTICLE}${SCHEMA_ORG}${SCHEMA_ITEMLIST}${SCHEMA_BREADCRUMB}${SCHEMA_FAQ}"

echo "Building about/index.html..."
build_page \
  "$ROOT/about/index.html" \
  "About This Guide — Best Antarctica Expedition Cruises" \
  "Learn about the editorial team, methodology, and independence principles behind the Best Antarctica Expedition Cruises ranking guide." \
  "${DOMAIN}/about/" \
  "$ROOT/pages/about.html" \
  "../" \
  "/about/"

echo "Building editorial-policy/index.html..."
build_page \
  "$ROOT/editorial-policy/index.html" \
  "Editorial Policy & Ranking Methodology — Best Antarctica Expedition Cruises" \
  "How we rank Antarctica expedition cruise operators: six criteria, weights, independence declaration, and update cycle." \
  "${DOMAIN}/editorial-policy/" \
  "$ROOT/pages/editorial-policy.html" \
  "../" \
  "/editorial-policy/"

echo "Building contact/index.html..."
build_page \
  "$ROOT/contact/index.html" \
  "Contact — Best Antarctica Expedition Cruises" \
  "Contact the editorial team for corrections, operator updates, or general inquiries." \
  "${DOMAIN}/contact/" \
  "$ROOT/pages/contact.html" \
  "../" \
  "/contact/"

echo "Building cookie-policy/index.html..."
build_page \
  "$ROOT/cookie-policy/index.html" \
  "Cookie Policy — Best Antarctica Expedition Cruises" \
  "Cookie policy for best-antarctica-expedition-cruises.com." \
  "${DOMAIN}/cookie-policy/" \
  "$ROOT/pages/cookie-policy.html" \
  "../" \
  "/cookie-policy/"

echo "Building terms/index.html..."
build_page \
  "$ROOT/terms/index.html" \
  "Terms & Disclaimer — Best Antarctica Expedition Cruises" \
  "Terms, conditions, and affiliate disclosure for best-antarctica-expedition-cruises.com." \
  "${DOMAIN}/terms/" \
  "$ROOT/pages/terms.html" \
  "../" \
  "/terms/"

# Cleanup
rm -f "$TMP_HEADER" "$TMP_FOOTER" "$TMP_CONTENT"

echo "✓ Build complete."
