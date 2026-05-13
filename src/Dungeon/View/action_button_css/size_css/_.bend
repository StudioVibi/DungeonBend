def action_button_size_css() -> String:
  "
  .db-action-button-wrap .bc-btn-medium,
  .db-action-button-wrap .bc-btn-large {
    min-height: 58px;
    padding: 1px 20px 0;
  }

  .db-action-button-wrap .bc-btn-medium:hover,
  .db-action-button-wrap .bc-btn-medium:active,
  .db-action-button-wrap .bc-btn-large:hover,
  .db-action-button-wrap .bc-btn-large:active {
    padding: 1px 20px 0;
  }

  .db-action-button-wrap .bc-btn-medium .bc-btn-label {
    font-size: 1rem;
  }

  .db-action-button-wrap .bc-btn-large .bc-btn-label {
    font-size: 1.18rem;
  }

  .db-action-button-wrap--back .bc-btn {
    min-width: 96px;
  }

  .db-action-button-wrap--icon .bc-btn {
    width: 56px;
    min-width: 56px;
    height: 56px;
    padding: 0;
  }

  .db-action-button-wrap--icon .bc-btn:hover,
  .db-action-button-wrap--icon .bc-btn:active {
    padding: 0;
  }

  .db-action-button-wrap--icon .bc-btn-content {
    width: 100%;
    height: 100%;
    justify-content: center;
    gap: 0;
  }

  .db-action-button-wrap--icon .bc-btn-label {
    display: none;
  }

  .db-action-button-wrap--icon .bc-btn-icon {
    width: 28px;
    height: 28px;
  }

  @media (max-width: 800px) {
    .db-action-button-wrap .bc-btn-medium,
    .db-action-button-wrap .bc-btn-large {
      min-height: 54px;
      padding: 1px 18px 0;
    }

    .db-action-button-wrap .bc-btn-medium:hover,
    .db-action-button-wrap .bc-btn-medium:active,
    .db-action-button-wrap .bc-btn-large:hover,
    .db-action-button-wrap .bc-btn-large:active {
      padding: 1px 18px 0;
    }

    .db-action-button-wrap .bc-btn-medium .bc-btn-label {
      font-size: 0.92rem;
    }

    .db-action-button-wrap .bc-btn-large .bc-btn-label {
      font-size: 1.04rem;
    }

    .db-action-button-wrap--back .bc-btn {
      min-width: 84px;
    }

    .db-action-button-wrap--icon .bc-btn {
      width: 48px;
      min-width: 48px;
      height: 48px;
      padding: 0;
    }

    .db-action-button-wrap--icon .bc-btn:hover,
    .db-action-button-wrap--icon .bc-btn:active {
      padding: 0;
    }

    .db-action-button-wrap--icon .bc-btn-icon {
      width: 24px;
      height: 24px;
    }
  }
  "
