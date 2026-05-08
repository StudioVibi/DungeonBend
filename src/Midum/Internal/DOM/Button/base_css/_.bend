def base_css() -> String:
  "
  .bc-btn {
    appearance: none;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    box-sizing: border-box;
    border: 1px solid transparent;
    background: transparent;
    color: inherit;
    font-family: var(--bc-font-ui);
    font-weight: 650;
    line-height: 1;
    letter-spacing: 0.01em;
    text-decoration: none;
    cursor: pointer;
    max-width: 100%;
    transition:
      background-color 120ms ease,
      border-color 120ms ease,
      color 120ms ease;
  }

  .bc-btn-content {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: var(--bc-btn-gap);
  }

  .bc-btn-label {
    white-space: nowrap;
  }

  .bc-btn-icon {
    width: var(--bc-btn-icon-size);
    height: var(--bc-btn-icon-size);
    object-fit: contain;
    flex: 0 0 auto;
  }

  .bc-btn-square {
    border-radius: 0;
  }

  .bc-btn-rounded {
    border-radius: 16px;
  }

  .bc-btn-small {
    min-height: 36px;
    padding: 0 14px;
    font-size: 14px;
    --bc-btn-gap: 8px;
    --bc-btn-icon-size: 14px;
  }

  .bc-btn-medium {
    min-height: 44px;
    padding: 0 18px;
    font-size: 16px;
    --bc-btn-gap: 10px;
    --bc-btn-icon-size: 16px;
  }

  .bc-btn-large {
    min-height: 52px;
    padding: 0 22px;
    font-size: 18px;
    --bc-btn-gap: 12px;
    --bc-btn-icon-size: 18px;
  }

  .bc-btn-fit {
    width: auto;
  }

  .bc-btn-wide {
    min-width: 224px;
  }

  .bc-btn-full {
    display: flex;
    width: 100%;
  }
  "
