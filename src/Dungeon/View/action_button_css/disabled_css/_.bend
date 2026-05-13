def action_button_disabled_css() -> String:
  "
  .db-action-button-wrap .bc-btn-disabled,
  .db-action-button-wrap .bc-btn-disabled:hover,
  .db-action-button-wrap .bc-btn-disabled:active,
  .db-action-button-wrap .bc-btn:disabled,
  .db-action-button-wrap .bc-btn:disabled:hover,
  .db-action-button-wrap .bc-btn:disabled:active {
    cursor: not-allowed;
    background: none;
    transform: none;
  }

  .db-action-button-wrap .bc-btn-disabled::before,
  .db-action-button-wrap .bc-btn:disabled::before {
    border-image-source: var(--db-action-button-disabled-image);
  }

  .db-action-button-wrap--back .bc-btn-disabled::before,
  .db-action-button-wrap--back .bc-btn:disabled::before {
    border-image-source: var(--db-action-button-small-disabled-image);
  }

  .db-action-button-wrap .bc-btn-disabled::after,
  .db-action-button-wrap .bc-btn-disabled:hover::after,
  .db-action-button-wrap .bc-btn:disabled::after,
  .db-action-button-wrap .bc-btn:disabled:hover::after {
    animation: none;
    opacity: 0;
  }

  .db-action-button-wrap .bc-btn-disabled .bc-btn-label,
  .db-action-button-wrap .bc-btn:disabled .bc-btn-label {
    color: var(--db-action-button-disabled-text);
    -webkit-text-stroke: var(--db-action-button-stroke-width) var(--db-action-button-disabled-stroke-color);
    opacity: var(--db-action-button-disabled-content-opacity);
  }

  .db-action-button-wrap .bc-btn-disabled .bc-btn-icon,
  .db-action-button-wrap .bc-btn:disabled .bc-btn-icon {
    opacity: var(--db-action-button-disabled-content-opacity);
  }
  "
