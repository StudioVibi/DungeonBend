def catoon_size_css() -> String:
  "
  .bc-btn-catoon.bc-btn-small {
    min-height: 40px;
    padding: 1px 16px 0;
  }

  .bc-btn-catoon.bc-btn-small:hover,
  .bc-btn-catoon.bc-btn-small:active {
    padding: 0 16px;
  }

  .bc-btn-catoon.bc-btn-small .bc-btn-label {
    font-size: 0.88rem;
    letter-spacing: 0.06em;
    -webkit-text-stroke: 1.1px var(--bc-catoon-text-stroke);
  }

  .bc-btn-catoon.bc-btn-medium {
    min-height: 48px;
    padding: 1px 20px 0;
  }

  .bc-btn-catoon.bc-btn-medium:hover,
  .bc-btn-catoon.bc-btn-medium:active {
    padding: 0 20px;
  }

  .bc-btn-catoon.bc-btn-medium .bc-btn-label {
    font-size: 1rem;
    -webkit-text-stroke: 1.4px var(--bc-catoon-text-stroke);
  }

  .bc-btn-catoon.bc-btn-large {
    min-height: 58px;
    padding: 1px 22px 0;
  }

  .bc-btn-catoon.bc-btn-large:hover,
  .bc-btn-catoon.bc-btn-large:active {
    padding: 0 22px;
  }

  .bc-btn-catoon.bc-btn-large .bc-btn-label {
    font-size: 1.18rem;
    -webkit-text-stroke: 1.8px var(--bc-catoon-text-stroke);
  }

  .bc-btn-catoon.bc-btn-disabled,
  .bc-btn-catoon.bc-btn-disabled:hover,
  .bc-btn-catoon.bc-btn-disabled:active,
  .bc-btn-catoon:disabled,
  .bc-btn-catoon:disabled:hover,
  .bc-btn-catoon:disabled:active {
    background: linear-gradient(
      to bottom,
      var(--bc-catoon-disabled-light) 0%,
      var(--bc-catoon-disabled-light) var(--bc-catoon-highlight-height),
      var(--bc-catoon-disabled-mid) var(--bc-catoon-highlight-height),
      var(--bc-catoon-disabled-mid) var(--bc-catoon-dark-start-normal),
      var(--bc-catoon-disabled-dark) var(--bc-catoon-dark-start-normal),
      var(--bc-catoon-disabled-dark) 100%
    );
    border-color: var(--bc-catoon-disabled-border);
    color: var(--bc-catoon-disabled-text);
  }

  .bc-btn-catoon.bc-btn-disabled .bc-btn-label,
  .bc-btn-catoon:disabled .bc-btn-label {
    color: var(--bc-catoon-disabled-text);
    -webkit-text-stroke: 1.2px var(--bc-catoon-disabled-text-stroke);
  }

  @media (max-width: 800px) {
    .bc-btn-catoon.bc-btn-small {
      min-height: 38px;
    }

    .bc-btn-catoon.bc-btn-small .bc-btn-label {
      font-size: 0.82rem;
    }

    .bc-btn-catoon.bc-btn-medium {
      min-height: 44px;
      padding: 1px 18px 0;
    }

    .bc-btn-catoon.bc-btn-medium:hover,
    .bc-btn-catoon.bc-btn-medium:active {
      padding: 0 18px;
    }

    .bc-btn-catoon.bc-btn-medium .bc-btn-label {
      font-size: 0.92rem;
    }

    .bc-btn-catoon.bc-btn-large .bc-btn-label {
      font-size: 1.04rem;
    }
  }
  "
