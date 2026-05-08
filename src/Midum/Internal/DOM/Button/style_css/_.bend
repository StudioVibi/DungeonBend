def style_css() -> String:
  "
  .bc-style-flat .bc-btn {
    border-width: 1px;
    box-shadow: none;
  }

  .bc-style-toon .bc-btn,
  .bc-style-toon .bc-btn:hover,
  .bc-style-toon .bc-btn:active,
  .bc-style-toon .bc-btn:disabled,
  .bc-style-toon .bc-btn:disabled:hover,
  .bc-style-toon .bc-btn:disabled:active {
    border-width: 2px;
    border-color: #000000;
    box-shadow: 0 2px 0 #000000;
  }

  .bc-btn:focus-visible {
    outline: 3px solid var(--bc-focus-ring);
    outline-offset: 3px;
  }

  .bc-style-toon .bc-btn:focus-visible {
    outline-offset: 5px;
  }
  "
