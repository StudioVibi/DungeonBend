def catoon_slice_css() -> String:
  "
  .bc-btn-catoon::before {
    content: '';
    position: absolute;
    inset: 0;
    z-index: -1;
    border-style: solid;
    border-width: 24px 12px;
    border-image-slice: 65 24 65 24 fill;
    border-image-width: 24px 12px;
    border-image-repeat: stretch;
    border-image-source: var(--bc-catoon-image);
    pointer-events: none;
  }

  .bc-btn-catoon.bc-btn-small::before {
    border-width: 18px 8px;
    border-image-slice: 38 16 38 16 fill;
    border-image-width: 18px 8px;
    border-image-source: var(--bc-catoon-small-image);
  }
  "
