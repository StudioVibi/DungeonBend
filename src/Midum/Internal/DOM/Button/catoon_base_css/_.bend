def catoon_base_css() -> String:
  "
  .bc-btn-catoon-wrap {
    --bc-catoon-radius: 12px;
    --bc-catoon-label-offset: -4px;
    --bc-catoon-stroke-width: 3px;
    --bc-catoon-stroke-color: #0a0e14;
    --bc-catoon-border: #0a0e14;
    --bc-catoon-shadow-offset-y: 2px;
    --bc-catoon-shadow-color: #000000;
    --bc-catoon-small-image: url(\"assets/ui/menu/button/button-main-small-gray.png\");
    --bc-catoon-small-disabled-image: url(\"assets/ui/menu/button/button-main-white.png\");
    --bc-catoon-text: #ffffff;
    --bc-catoon-disabled-text: #fff9ea;
    --bc-catoon-disabled-stroke-color: #615648;
    --bc-catoon-disabled-image: url(\"assets/ui/menu/button/button-main-white.png\");
    --bc-catoon-disabled-content-opacity: 0.58;
    position: relative;
    display: inline-grid;
    max-width: 100%;
  }

  .bc-btn-catoon-wrap:has(>.bc-btn-full) {
    display: grid;
    width: 100%;
  }

  .bc-btn-catoon {
    position: relative;
    z-index: 0;
    isolation: isolate;
    overflow: hidden;
    border: 0 !important;
    border-radius: var(--bc-catoon-radius);
    background: none;
    color: var(--bc-catoon-text);
    box-shadow: none;
    transform: none;
    filter: none;
    transition: none;
  }

  .bc-btn-catoon:hover,
  .bc-btn-catoon:active {
    background: none;
    border-color: transparent;
    box-shadow: none;
    transform: none;
  }

  .bc-btn-catoon .bc-btn-content {
    position: relative;
    z-index: 1;
    width: 100%;
  }

  .bc-btn-catoon .bc-btn-label {
    color: var(--bc-catoon-text);
    font-family: var(--bc-font-display);
    font-weight: 800;
    line-height: 1;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    paint-order: stroke fill;
    transform: translateY(var(--bc-catoon-label-offset));
    -webkit-text-stroke: var(--bc-catoon-stroke-width) var(--bc-catoon-stroke-color);
    filter: drop-shadow(0 var(--bc-catoon-shadow-offset-y) 0 var(--bc-catoon-shadow-color));
    white-space: nowrap;
  }

  .bc-btn-catoon:focus-visible {
    outline-offset: 6px;
  }
  "
