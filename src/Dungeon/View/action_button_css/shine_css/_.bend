def action_button_shine_css() -> String:
  "
  .db-action-button-wrap .bc-btn::after {
    content: '';
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    width: 60%;
    pointer-events: none;
    background: linear-gradient(
      90deg,
      rgba(255, 255, 255, 0) 0%,
      rgba(255, 255, 255, 0.9) 50%,
      rgba(255, 255, 255, 0) 100%
    );
    transform: translateX(-180%) skewX(-18deg);
    opacity: 0;
    z-index: 2;
  }

  @media (hover: hover) and (pointer: fine) {
    .db-action-button-wrap .bc-btn:not(:disabled):hover::after {
      animation: db-action-button-shine-sweep 620ms cubic-bezier(0.22, 0.61, 0.36, 1) 1 both;
    }
  }

  @keyframes db-action-button-shine-sweep {
    0% { transform: translateX(-180%) skewX(-18deg); opacity: 0; }
    20% { opacity: 1; }
    80% { opacity: 1; }
    100% { transform: translateX(220%) skewX(-18deg); opacity: 0; }
  }
  "
