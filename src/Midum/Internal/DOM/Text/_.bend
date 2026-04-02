# Internal DOM text renderer for Midum.
#
# This module maps concrete text config values to the current DOM renderer.

import /HTML/

def align_class(align: Midum/Text/Align) -> String:
  match align:
    case left{}:
      "bc-text-left"
    case center{}:
      "bc-text-center"
    case right{}:
      "bc-text-right"

def variant_class(variant: Midum/Text/Variant) -> String:
  match variant:
    case label{}:
      "bc-text-label"
    case heading_1{}:
      "bc-text-h1"
    case heading_2{}:
      "bc-text-h2"
    case body{}:
      "bc-text-body"

def color_class(color: Midum/Text/Color) -> String:
  match color:
    case inherited{}:
      ""
    case primary{}:
      "bc-text-primary"
    case secondary{}:
      "bc-text-secondary"
    case neutral{}:
      "bc-text-neutral"
    case success{}:
      "bc-text-success"
    case warning{}:
      "bc-text-warning"
    case danger{}:
      "bc-text-danger"

def text_class(variant: Midum/Text/Variant, align: Midum/Text/Align, color: Midum/Text/Color) -> String:
  "bc-text " ++ variant_class(variant) ++ " " ++ align_class(align) ++ " " ++ color_class(color)

def interactive_content(Event: Type, content: String, interaction: Midum/Text/Interaction(Event)) -> HTML(Event):
  match interaction:
    case static{}:
      text{content}
    case navigate{href}:
      <a class="bc-text-link" href={href}>{text{content}}</a>
    case trigger{evt}:
      <button class="bc-text-action" type="button" on_click={evt}>{text{content}}</button>

def render_variant(Event: Type, content: String, variant: Midum/Text/Variant, align: Midum/Text/Align, interaction: Midum/Text/Interaction(Event), color: Midum/Text/Color) -> HTML(Event):
  match variant:
    case label{}:
      <div class={text_class(variant, align, color)}>{interactive_content(Event, content, interaction)}</div>
    case heading_1{}:
      <h1 class={text_class(variant, align, color)}>{interactive_content(Event, content, interaction)}</h1>
    case heading_2{}:
      <h2 class={text_class(variant, align, color)}>{interactive_content(Event, content, interaction)}</h2>
    case body{}:
      <p class={text_class(variant, align, color)}>{interactive_content(Event, content, interaction)}</p>

def render(Event: Type, cfg: Midum/Text/Config(Event)) -> HTML(Event):
  match cfg:
    case copy{content, variant, align, interaction, color}:
      render_variant(Event, content, variant, align, interaction, color)

def css() -> String:
  "
  .bc-text {
    margin: 0;
    color: inherit;
    max-width: 100%;
  }

  .bc-text-link,
  .bc-text-action {
    color: inherit;
    font-family: inherit;
    font-size: inherit;
    font-weight: inherit;
    line-height: inherit;
    letter-spacing: inherit;
    text-decoration-line: underline;
    text-decoration-thickness: 0.08em;
    text-decoration-color: currentColor;
    text-underline-offset: 0.12em;
    transition:
      opacity 120ms ease,
      color 120ms ease;
  }

  .bc-text-link:visited {
    color: inherit;
  }

  .bc-text-link:hover,
  .bc-text-action:hover {
    opacity: 0.72;
  }

  .bc-text-action {
    appearance: none;
    background: transparent;
    border: 0;
    padding: 0;
    margin: 0;
    cursor: pointer;
  }

  .bc-text-label {
    font-family: var(--bc-font-display);
    font-size: 13px;
    font-weight: 800;
    line-height: 1.1;
    letter-spacing: 0.22em;
  }

  .bc-text-h1 {
    font-family: var(--bc-font-display);
    font-size: 40px;
    font-weight: 700;
    line-height: 1.0;
  }

  .bc-text-h2 {
    font-family: var(--bc-font-display);
    font-size: 28px;
    font-weight: 700;
    line-height: 1.1;
  }

  .bc-text-body {
    font-family: var(--bc-font-ui);
    font-size: 16px;
    font-weight: 400;
    line-height: 1.5;
  }

  .bc-text-left {
    text-align: left;
  }

  .bc-text-center {
    text-align: center;
  }

  .bc-text-right {
    text-align: right;
  }

  .bc-text-primary {
    color: var(--bc-primary-copy);
  }

  .bc-text-secondary {
    color: var(--bc-secondary-copy);
  }

  .bc-text-neutral {
    color: var(--bc-neutral-copy);
  }

  .bc-text-success {
    color: var(--bc-success-copy);
  }

  .bc-text-warning {
    color: var(--bc-warning-copy);
  }

  .bc-text-danger {
    color: var(--bc-danger-copy);
  }

  "
