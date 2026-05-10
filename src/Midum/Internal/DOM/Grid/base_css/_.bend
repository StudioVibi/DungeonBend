def base_css() -> String:
  "
  .bc-grid {
    display: block;
    position: relative;
    box-sizing: border-box;
    width: 100%;
    max-width: 100%;
    min-width: 0;
  }

  .bc-grid-svg {
    display: block;
    width: 100%;
    height: auto;
  }

  .bc-grid-content-layer {
    position: absolute;
    z-index: 2;
    pointer-events: none;
    box-sizing: border-box;
  }

  .bc-grid-content-row {
    position: absolute;
    box-sizing: border-box;
    pointer-events: none;
  }

  .bc-grid-content-cell {
    position: absolute;
    box-sizing: border-box;
    overflow: hidden;
    display: grid;
    place-items: center;
    pointer-events: auto;
  }

  .bc-grid-content-cell-inner {
    display: grid;
    place-items: center;
    width: 100%;
    height: 100%;
    min-width: 0;
    min-height: 0;
  }
  "
