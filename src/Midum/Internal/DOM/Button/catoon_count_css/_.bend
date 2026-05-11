def catoon_count_css() -> String:
  "
  .bc-btn-catoon-count {
    justify-content: flex-start;
    padding-right: 52px;
  }

  .bc-btn-catoon-count .bc-btn-content {
    justify-content: flex-start;
  }

  .bc-btn-catoon-count__badge {
    position: absolute;
    top: 50%;
    right: 0;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 34px;
    min-height: 24px;
    padding: 4px 8px;
    border: 3px solid var(--bc-catoon-border);
    border-radius: 10px;
    background: linear-gradient(to bottom, #ffe49d 0%, #ffe49d 35%, #f0b43d 35%, #f0b43d 100%);
    color: #fff8e8;
    font-family: var(--bc-font-display);
    font-size: 0.82rem;
    font-weight: 800;
    line-height: 1;
    letter-spacing: 0.04em;
    -webkit-text-stroke: 1px #8e5910;
    paint-order: stroke fill;
    transform: translate(28%, -50%);
    pointer-events: none;
    box-shadow: 0 3px 0 0 var(--bc-catoon-border);
  }

  @media (max-width: 800px) {
    .bc-btn-catoon-count {
      padding-right: 46px;
    }

    .bc-btn-catoon-count__badge {
      font-size: 0.74rem;
      box-shadow: 0 2px 0 0 var(--bc-catoon-border);
    }
  }
  "
