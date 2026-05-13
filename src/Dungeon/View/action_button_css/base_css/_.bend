def action_button_base_css() -> String:
  "
  .db-action-button-wrap {
    --db-action-button-radius: 12px;
    --db-action-button-label-offset: -4px;
    --db-action-button-stroke-width: 3px;
    --db-action-button-stroke-color: #0a0e14;
    --db-action-button-shadow-offset-y: 2px;
    --db-action-button-shadow-color: #000000;
    --db-action-button-small-image: url(\"assets/ui/menu/button/button-main-small-gray.png\");
    --db-action-button-small-disabled-image: url(\"assets/ui/menu/button/button-main-white.png\");
    --db-action-button-text: #ffffff;
    --db-action-button-disabled-text: #fff9ea;
    --db-action-button-disabled-stroke-color: #615648;
    --db-action-button-disabled-image: url(\"assets/ui/menu/button/button-main-white.png\");
    --db-action-button-disabled-content-opacity: 0.58;
    position: relative;
    display: inline-grid;
    max-width: 100%;
  }

  .db-action-button-wrap:has(>.bc-btn-full) {
    display: grid;
    width: 100%;
  }

  .db-action-button-wrap .bc-btn {
    position: relative;
    z-index: 0;
    isolation: isolate;
    overflow: hidden;
    border: 0 !important;
    border-radius: var(--db-action-button-radius);
    background: none;
    color: var(--db-action-button-text);
    box-shadow: none;
    transform: none;
    filter: none;
    transition: none;
  }

  .db-action-button-wrap .bc-btn:hover,
  .db-action-button-wrap .bc-btn:active {
    background: none;
    border-color: transparent;
    box-shadow: none;
    transform: none;
  }

  .db-action-button-wrap .bc-btn-content {
    position: relative;
    z-index: 1;
    width: 100%;
  }

  .db-action-button-wrap .bc-btn-label {
    color: var(--db-action-button-text);
    font-family: var(--bc-font-display);
    font-weight: 800;
    line-height: 1;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    paint-order: stroke fill;
    transform: translateY(var(--db-action-button-label-offset));
    -webkit-text-stroke: var(--db-action-button-stroke-width) var(--db-action-button-stroke-color);
    filter: drop-shadow(0 var(--db-action-button-shadow-offset-y) 0 var(--db-action-button-shadow-color));
    white-space: nowrap;
  }

  .db-action-button-wrap .bc-btn:focus-visible {
    outline-offset: 6px;
  }
  "
