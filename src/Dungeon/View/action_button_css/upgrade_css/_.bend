def action_button_upgrade_css() -> String:
  "
  .db-action-button-wrap--upgrade-available .bc-btn:not(:disabled)::after {
    animation: db-upgrade-flash-idle 3000ms cubic-bezier(0.22, 0.61, 0.36, 1) infinite both;
  }

  .db-action-button-wrap--upgrade-available:active {
    animation: character-upgrade-jelly 1180ms cubic-bezier(0.2, 0.82, 0.2, 1) 1 both;
    transform-origin: 50% 78%;
  }

  @media (hover: hover) and (pointer: fine) {
    .db-action-button-wrap--upgrade-available .bc-btn:not(:disabled):hover::after {
      animation: none;
    }

    .db-action-button-wrap--upgrade-available:hover {
      animation: character-upgrade-jelly 1180ms cubic-bezier(0.2, 0.82, 0.2, 1) infinite;
      transform-origin: 50% 78%;
    }
  }

  @keyframes db-upgrade-flash-idle {
    0% { transform: translateX(-180%) skewX(-18deg); opacity: 0; }
    4% { opacity: 1; }
    16% { opacity: 1; }
    20% { transform: translateX(220%) skewX(-18deg); opacity: 0; }
    100% { transform: translateX(220%) skewX(-18deg); opacity: 0; }
  }
  "
