def catoon_disabled_css() -> String:
  "
  .bc-btn-catoon.bc-btn-disabled,
  .bc-btn-catoon.bc-btn-disabled:hover,
  .bc-btn-catoon.bc-btn-disabled:active,
  .bc-btn-catoon:disabled,
  .bc-btn-catoon:disabled:hover,
  .bc-btn-catoon:disabled:active {
    cursor: not-allowed;
    background: none;
    transform: none;
  }

  .bc-btn-catoon.bc-btn-disabled::before,
  .bc-btn-catoon:disabled::before {
    border-image-source: var(--bc-catoon-disabled-image);
  }

  .bc-btn-catoon.bc-btn-small.bc-btn-disabled::before,
  .bc-btn-catoon.bc-btn-small:disabled::before {
    border-image-source: var(--bc-catoon-small-disabled-image);
  }

  .bc-btn-catoon.bc-btn-disabled::after,
  .bc-btn-catoon.bc-btn-disabled:hover::after,
  .bc-btn-catoon:disabled::after,
  .bc-btn-catoon:disabled:hover::after {
    animation: none;
    opacity: 0;
  }

  .bc-btn-catoon.bc-btn-disabled .bc-btn-label,
  .bc-btn-catoon:disabled .bc-btn-label {
    color: var(--bc-catoon-disabled-text);
    -webkit-text-stroke: var(--bc-catoon-stroke-width) var(--bc-catoon-disabled-stroke-color);
    opacity: var(--bc-catoon-disabled-content-opacity);
  }

  .bc-btn-catoon.bc-btn-disabled .bc-btn-icon,
  .bc-btn-catoon:disabled .bc-btn-icon {
    opacity: var(--bc-catoon-disabled-content-opacity);
  }
  "
