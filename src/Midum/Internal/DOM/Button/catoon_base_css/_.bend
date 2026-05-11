def catoon_base_css() -> String:
  "
  .bc-btn-catoon-wrap {
    --bc-catoon-base-height: 5px;
    --bc-catoon-highlight-height: 4px;
    --bc-catoon-dark-start-normal: 92%;
    --bc-catoon-dark-start-hover: 94%;
    --bc-catoon-radius: 14px;
    --bc-catoon-top-border-normal: 2px;
    --bc-catoon-top-border-hover: 3px;
    --bc-catoon-side-border: 3px;
    --bc-catoon-bottom-border: 3px;
    --bc-catoon-border: #0a0e14;
    --bc-catoon-shadow: #0a0e14;
    --bc-catoon-text: #ffffff;
    --bc-catoon-text-stroke: #0a0e14;
    --bc-catoon-disabled-border: #515a67;
    --bc-catoon-disabled-shadow: #515a67;
    --bc-catoon-disabled-text: #f5f7fa;
    --bc-catoon-disabled-text-stroke: #515a67;
    position: relative;
    display: inline-grid;
    max-width: 100%;
  }

  .bc-btn-catoon-wrap:has(>.bc-btn-full) {
    display: grid;
    width: 100%;
  }

  .bc-btn-catoon-wrap::after {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: var(--bc-catoon-radius);
    transform: translateY(var(--bc-catoon-base-height));
    background: var(--bc-catoon-shadow);
    z-index: 0;
    pointer-events: none;
  }

  .bc-btn-catoon-wrap:has(>.bc-btn-disabled)::after,
  .bc-btn-catoon-wrap:has(>.bc-btn:disabled)::after {
    background: var(--bc-catoon-disabled-shadow);
  }

  .bc-btn-catoon {
    position: relative;
    z-index: 1;
    border-style: solid;
    border-width: var(--bc-catoon-top-border-normal) var(--bc-catoon-side-border) var(--bc-catoon-bottom-border) var(--bc-catoon-side-border) !important;
    border-color: var(--bc-catoon-border);
    background: linear-gradient(
      to bottom,
      var(--bc-catoon-light) 0%,
      var(--bc-catoon-light) var(--bc-catoon-highlight-height),
      var(--bc-catoon-mid) var(--bc-catoon-highlight-height),
      var(--bc-catoon-mid) var(--bc-catoon-dark-start-normal),
      var(--bc-catoon-dark) var(--bc-catoon-dark-start-normal),
      var(--bc-catoon-dark) 100%
    );
    color: var(--bc-catoon-text);
    box-shadow: none;
    overflow: visible;
    transform: none;
    filter: none;
    transition: none;
  }

  .bc-btn-catoon:hover,
  .bc-btn-catoon:active {
    border-width: var(--bc-catoon-top-border-hover) var(--bc-catoon-side-border) var(--bc-catoon-bottom-border) var(--bc-catoon-side-border) !important;
    background: linear-gradient(
      to bottom,
      var(--bc-catoon-light) 0%,
      var(--bc-catoon-light) var(--bc-catoon-highlight-height),
      var(--bc-catoon-mid) var(--bc-catoon-highlight-height),
      var(--bc-catoon-mid) var(--bc-catoon-dark-start-hover),
      var(--bc-catoon-dark) var(--bc-catoon-dark-start-hover),
      var(--bc-catoon-dark) 100%
    );
  }

  .bc-btn-catoon.bc-btn-rounded {
    border-radius: var(--bc-catoon-radius);
  }

  .bc-btn-catoon .bc-btn-content {
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
    transform: translateY(-1px);
  }

  .bc-btn-catoon:hover .bc-btn-label,
  .bc-btn-catoon:active .bc-btn-label {
    transform: translateY(0);
  }

  .bc-btn-catoon:focus-visible {
    outline-offset: 6px;
  }
  "
