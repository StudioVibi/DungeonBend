# Internal DOM button renderer for Midum.
#
# This module maps concrete inline button{...} values to the current DOM
# renderer and theme tracks.

import HTML as HTML

def primary(Event: Type, evt: Event, cfg: Midum/Button/Config) -> HTML(Event):
  button(Event, evt, cfg, "bc-btn-primary")

def catoon(Event: Type, evt: Event, cfg: Midum/Button/Config) -> HTML(Event):
  wrapped_button(Event, evt, cfg, "bc-btn-catoon-wrap", "bc-btn-primary bc-btn-catoon")

def catoon_secondary(Event: Type, evt: Event, cfg: Midum/Button/Config) -> HTML(Event):
  wrapped_button(Event, evt, cfg, "bc-btn-catoon-wrap", "bc-btn-secondary bc-btn-catoon")

def secondary(Event: Type, evt: Event, cfg: Midum/Button/Config) -> HTML(Event):
  button(Event, evt, cfg, "bc-btn-secondary")

def neutral(Event: Type, evt: Event, cfg: Midum/Button/Config) -> HTML(Event):
  button(Event, evt, cfg, "bc-btn-neutral")

def success(Event: Type, evt: Event, cfg: Midum/Button/Config) -> HTML(Event):
  button(Event, evt, cfg, "bc-btn-success")

def warning(Event: Type, evt: Event, cfg: Midum/Button/Config) -> HTML(Event):
  button(Event, evt, cfg, "bc-btn-warning")

def danger(Event: Type, evt: Event, cfg: Midum/Button/Config) -> HTML(Event):
  button(Event, evt, cfg, "bc-btn-danger")

# Maps shape to the CSS class that controls radius.
def shape_class(shape: Midum/Button/Shape) -> String:
  match shape:
    case square{}:
      "bc-btn-square"
    case rounded{}:
      "bc-btn-rounded"

# Maps size to the CSS class that controls padding and type scale.
def size_class(size: Midum/Button/Size) -> String:
  match size:
    case small{}:
      "bc-btn-small"
    case medium{}:
      "bc-btn-medium"
    case large{}:
      "bc-btn-large"

# Maps width to the CSS class that controls horizontal behavior.
def width_class(width: Midum/Button/Width) -> String:
  match width:
    case fit{}:
      "bc-btn-fit"
    case wide{}:
      "bc-btn-wide"
    case full{}:
      "bc-btn-full"

# Adds a class for icon placement so layout stays explicit.
def icon_class(icon: Midum/Button/Icon) -> String:
  match icon:
    case left{src}:
      "bc-btn-icon-left"
    case right{src}:
      "bc-btn-icon-right"
    case off{}:
      ""

# Adds a class when the button resolves to the disabled state.
def state_class(state: Midum/Button/State) -> String:
  match state:
    case disabled{}:
      "bc-btn-disabled"
    case enabled{}:
      ""

# Builds the final DOM class string from role + resolved inline fields.
def button_class(role_class: String, icon: Midum/Button/Icon, shape: Midum/Button/Shape, size: Midum/Button/Size, width: Midum/Button/Width, state: Midum/Button/State) -> String:
  "bc-btn " ++ role_class ++ " " ++ shape_class(shape) ++ " " ++ size_class(size) ++ " " ++ width_class(width) ++ " " ++ icon_class(icon) ++ " " ++ state_class(state)

# Renders an optional left icon.
def left_icon(Event: Type, icon: Midum/Button/Icon) -> HTML(Event):
  match icon:
    case left{src}:
      <img class="bc-btn-icon" src={src} alt="" />
    case off{}:
      text{""}
    case right{src}:
      text{""}

# Renders an optional right icon.
def right_icon(Event: Type, icon: Midum/Button/Icon) -> HTML(Event):
  match icon:
    case right{src}:
      <img class="bc-btn-icon" src={src} alt="" />
    case off{}:
      text{""}
    case left{src}:
      text{""}

# Shared button contents: optional left icon, label, optional right icon.
def contents(Event: Type, label: String, icon: Midum/Button/Icon) -> HTML(Event):
  <span class="bc-btn-content">
    {left_icon(Event, icon)}
    <span class="bc-btn-label">{text{label}}</span>
    {right_icon(Event, icon)}
  </span>

def catoon_palette_style(catoon_palette: Maybe(Midum/Button/CatoonPalette)) -> String:
  match catoon_palette:
    case some{palette{light, mid, dark}}:
      "--bc-catoon-light:" ++ light ++ ";--bc-catoon-mid:" ++ mid ++ ";--bc-catoon-dark:" ++ dark ++ ";"
    case none{}:
      ""

# Final DOM branch once inline fields have already been resolved.
def render_resolved(Event: Type, evt: Event, role_class: String, label: String, icon: Midum/Button/Icon, shape: Midum/Button/Shape, size: Midum/Button/Size, width: Midum/Button/Width, state: Midum/Button/State, catoon_palette: Maybe(Midum/Button/CatoonPalette)) -> HTML(Event):
  match state:
    case disabled{}:
      <button class={button_class(role_class, icon, shape, size, width, state)} style={catoon_palette_style(catoon_palette)} type="button" disabled="disabled">
        {contents(Event, label, icon)}
      </button>
    case enabled{}:
      <button class={button_class(role_class, icon, shape, size, width, state)} style={catoon_palette_style(catoon_palette)} type="button" on_click={evt}>
        {contents(Event, label, icon)}
      </button>

# One shared renderer for primary / secondary / danger with concrete inline
# values only.
def button(Event: Type, evt: Event, cfg: Midum/Button/Config, role_class: String) -> HTML(Event):
  match cfg:
    case button{text, icon, shape, size, width, state, catoon_palette}:
      render_resolved(Event, evt, role_class, text, icon, shape, size, width, state, catoon_palette)

def wrapped_button(Event: Type, evt: Event, cfg: Midum/Button/Config, wrap_class: String, role_class: String) -> HTML(Event):
  <span class={wrap_class}>
    {button(Event, evt, cfg, role_class)}
  </span>

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

def role_css() -> String:
  "
  .bc-btn-primary {
    background: var(--bc-primary-bg);
    color: var(--bc-primary-text);
    border-color: var(--bc-primary-border);
  }

  .bc-btn-primary:hover {
    background: var(--bc-primary-hover-bg);
  }

  .bc-btn-primary:active {
    background: var(--bc-primary-active-bg);
  }

  .bc-btn-secondary {
    background: var(--bc-secondary-bg);
    color: var(--bc-secondary-text);
    border-color: var(--bc-secondary-border);
  }

  .bc-btn-secondary:hover {
    background: var(--bc-secondary-hover-bg);
  }

  .bc-btn-secondary:active {
    background: var(--bc-secondary-active-bg);
  }

  .bc-btn-neutral {
    background: var(--bc-neutral-bg);
    color: var(--bc-neutral-text);
    border-color: var(--bc-neutral-border);
  }

  .bc-btn-neutral:hover {
    background: var(--bc-neutral-hover-bg);
  }

  .bc-btn-neutral:active {
    background: var(--bc-neutral-active-bg);
  }

  .bc-btn-success {
    background: var(--bc-success-bg);
    color: var(--bc-success-text);
    border-color: var(--bc-success-border);
  }

  .bc-btn-success:hover {
    background: var(--bc-success-hover-bg);
  }

  .bc-btn-success:active {
    background: var(--bc-success-active-bg);
  }

  .bc-btn-warning {
    background: var(--bc-warning-bg);
    color: var(--bc-warning-text);
    border-color: var(--bc-warning-border);
  }

  .bc-btn-warning:hover {
    background: var(--bc-warning-hover-bg);
  }

  .bc-btn-warning:active {
    background: var(--bc-warning-active-bg);
  }

  .bc-btn-danger {
    background: var(--bc-danger-bg);
    color: var(--bc-danger-text);
    border-color: var(--bc-danger-border);
  }

  .bc-btn-danger:hover {
    background: var(--bc-danger-hover-bg);
  }

  .bc-btn-danger:active {
    background: var(--bc-danger-active-bg);
  }

  .bc-btn-primary.bc-btn-catoon {
    --bc-catoon-light: var(--bc-primary-gradient-from);
    --bc-catoon-mid: var(--bc-primary-bg);
    --bc-catoon-dark: var(--bc-primary-gradient-to);
  }

  .bc-btn-secondary.bc-btn-catoon {
    --bc-catoon-light: var(--bc-secondary-gradient-from);
    --bc-catoon-mid: var(--bc-secondary-bg);
    --bc-catoon-dark: var(--bc-secondary-gradient-to);
  }

  .bc-btn-neutral.bc-btn-catoon {
    --bc-catoon-light: var(--bc-neutral-gradient-from);
    --bc-catoon-mid: var(--bc-neutral-bg);
    --bc-catoon-dark: var(--bc-neutral-gradient-to);
  }

  .bc-btn-success.bc-btn-catoon {
    --bc-catoon-light: var(--bc-success-gradient-from);
    --bc-catoon-mid: var(--bc-success-bg);
    --bc-catoon-dark: var(--bc-success-gradient-to);
  }

  .bc-btn-warning.bc-btn-catoon {
    --bc-catoon-light: var(--bc-warning-gradient-from);
    --bc-catoon-mid: var(--bc-warning-bg);
    --bc-catoon-dark: var(--bc-warning-gradient-to);
  }

  .bc-btn-danger.bc-btn-catoon {
    --bc-catoon-light: var(--bc-danger-gradient-from);
    --bc-catoon-mid: var(--bc-danger-bg);
    --bc-catoon-dark: var(--bc-danger-gradient-to);
  }

  .bc-btn-catoon-wrap {
    --bc-catoon-base-height: 5px;
    --bc-catoon-highlight-height: 4px;
    --bc-catoon-radius: 14px;
    --bc-catoon-top-overlay-height: 1px;
    --bc-catoon-top-overlay-color: var(--bc-catoon-light);
    --bc-catoon-dark-start-normal: 92%;
    --bc-catoon-dark-start-hover: 94%;
    position: relative;
    display: inline-grid;
    max-width: 100%;
  }

  .bc-btn-catoon-wrap:has(>.bc-btn-full) {
    display: grid;
    width: 100%;
  }

  .bc-btn-catoon-wrap::after {
    content: \"\";
    position: absolute;
    inset: 0;
    border-radius: var(--bc-catoon-radius);
    background: var(--bc-primary-border);
    transform: translateY(var(--bc-catoon-base-height));
    z-index: 0;
    pointer-events: none;
  }

  .bc-btn-catoon-wrap:has(>.bc-btn-primary)::after {
    background: var(--bc-primary-border);
  }

  .bc-btn-catoon-wrap:has(>.bc-btn-secondary)::after {
    background: var(--bc-secondary-border);
  }

  .bc-btn-catoon-wrap:has(>.bc-btn-neutral)::after {
    background: var(--bc-neutral-border);
  }

  .bc-btn-catoon-wrap:has(>.bc-btn-success)::after {
    background: var(--bc-success-border);
  }

  .bc-btn-catoon-wrap:has(>.bc-btn-warning)::after {
    background: var(--bc-warning-border);
  }

  .bc-btn-catoon-wrap:has(>.bc-btn-danger)::after {
    background: var(--bc-danger-border);
  }

  .bc-btn-catoon-wrap:has(>.bc-btn-disabled)::after,
  .bc-btn-catoon-wrap:has(>.bc-btn:disabled)::after {
    background: var(--bc-disabled-border);
  }

  .bc-btn-catoon-wrap > .bc-btn {
    position: relative;
    z-index: 1;
  }

  .bc-btn.bc-btn-catoon {
    border-width: 3px;
    border-style: solid;
    position: relative;
    background: linear-gradient(
      to bottom,
      var(--bc-catoon-light) 0%,
      var(--bc-catoon-light) var(--bc-catoon-highlight-height),
      var(--bc-catoon-mid) var(--bc-catoon-highlight-height),
      var(--bc-catoon-mid) var(--bc-catoon-dark-start-normal),
      var(--bc-catoon-dark) var(--bc-catoon-dark-start-normal),
      var(--bc-catoon-dark) 100%
    );
    box-shadow: none;
    overflow: hidden;
    transform: none;
    filter: none;
  }

  .bc-btn.bc-btn-catoon::before {
    content: \"\";
    position: absolute;
    inset: 0 0 auto 0;
    height: var(--bc-catoon-top-overlay-height);
    background: var(--bc-catoon-top-overlay-color);
    pointer-events: none;
    z-index: 0;
  }

  .bc-btn.bc-btn-catoon:hover,
  .bc-btn.bc-btn-catoon:active {
    background: linear-gradient(
      to bottom,
      var(--bc-catoon-light) 0%,
      var(--bc-catoon-light) var(--bc-catoon-highlight-height),
      var(--bc-catoon-mid) var(--bc-catoon-highlight-height),
      var(--bc-catoon-mid) var(--bc-catoon-dark-start-hover),
      var(--bc-catoon-dark) var(--bc-catoon-dark-start-hover),
      var(--bc-catoon-dark) 100%
    );
  }

  .bc-btn.bc-btn-catoon:hover::before,
  .bc-btn.bc-btn-catoon:active::before {
    height: 0;
  }

  .bc-btn.bc-btn-catoon.bc-btn-rounded {
    border-radius: var(--bc-catoon-radius);
  }

  .bc-btn.bc-btn-catoon .bc-btn-content {
    width: 100%;
  }

  .bc-btn.bc-btn-catoon .bc-btn-label {
    position: relative;
    z-index: 1;
    line-height: 1;
    transform: translateY(-1px);
  }

  .bc-btn.bc-btn-catoon:hover .bc-btn-label,
  .bc-btn.bc-btn-catoon:active .bc-btn-label {
    transform: translateY(0);
  }

  .bc-btn.bc-btn-catoon.bc-btn-small {
    min-height: 40px;
    padding: 1px 16px 0;
  }

  .bc-btn.bc-btn-catoon.bc-btn-small:hover,
  .bc-btn.bc-btn-catoon.bc-btn-small:active {
    padding: 0 16px;
  }

  .bc-btn.bc-btn-catoon.bc-btn-small .bc-btn-label {
    font-size: 0.88rem;
  }

  .bc-btn.bc-btn-catoon.bc-btn-medium {
    min-height: 48px;
    padding: 1px 20px 0;
  }

  .bc-btn.bc-btn-catoon.bc-btn-medium:hover,
  .bc-btn.bc-btn-catoon.bc-btn-medium:active {
    padding: 0 20px;
  }

  .bc-btn.bc-btn-catoon.bc-btn-medium .bc-btn-label {
    font-size: 1rem;
  }

  .bc-btn.bc-btn-catoon.bc-btn-large {
    min-height: 58px;
    padding: 1px 22px 0;
  }

  .bc-btn.bc-btn-catoon.bc-btn-large:hover,
  .bc-btn.bc-btn-catoon.bc-btn-large:active {
    padding: 0 22px;
  }

  .bc-btn.bc-btn-catoon.bc-btn-large .bc-btn-label {
    font-size: 1.18rem;
  }

  .bc-btn.bc-btn-catoon:focus-visible {
    outline-offset: 6px;
  }

  .bc-btn.bc-btn-catoon.bc-btn-disabled,
  .bc-btn.bc-btn-catoon.bc-btn-disabled:hover,
  .bc-btn.bc-btn-catoon.bc-btn-disabled:active,
  .bc-btn.bc-btn-catoon:disabled,
  .bc-btn.bc-btn-catoon:disabled:hover,
  .bc-btn.bc-btn-catoon:disabled:active {
    --bc-catoon-top-overlay-color: var(--bc-disabled-bg);
    background: linear-gradient(
      to bottom,
      var(--bc-disabled-bg) 0%,
      var(--bc-disabled-bg) var(--bc-catoon-highlight-height),
      var(--bc-disabled-bg) var(--bc-catoon-highlight-height),
      var(--bc-disabled-bg) var(--bc-catoon-dark-start-normal),
      var(--bc-disabled-border) var(--bc-catoon-dark-start-normal),
      var(--bc-disabled-border) 100%
    );
    border-color: var(--bc-disabled-border);
    color: var(--bc-disabled-text);
    box-shadow: none;
    transform: none;
    filter: none;
  }

  .bc-btn-disabled,
  .bc-btn-disabled:hover,
  .bc-btn-disabled:active,
  .bc-btn:disabled,
  .bc-btn:disabled:hover,
  .bc-btn:disabled:active {
    background: var(--bc-disabled-bg);
    color: var(--bc-disabled-text);
    border-color: var(--bc-disabled-border);
    cursor: not-allowed;
  }
  "

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

  @media (max-width: 800px) {
    .bc-btn.bc-btn-catoon.bc-btn-small {
      min-height: 38px;
      padding: 1px 14px 0;
    }

    .bc-btn.bc-btn-catoon.bc-btn-small:hover,
    .bc-btn.bc-btn-catoon.bc-btn-small:active {
      padding: 0 14px;
    }

    .bc-btn.bc-btn-catoon.bc-btn-medium {
      min-height: 44px;
      padding: 1px 18px 0;
    }

    .bc-btn.bc-btn-catoon.bc-btn-medium:hover,
    .bc-btn.bc-btn-catoon.bc-btn-medium:active {
      padding: 0 18px;
    }

    .bc-btn.bc-btn-catoon.bc-btn-large {
      min-height: 52px;
      padding: 1px 18px 0;
    }

    .bc-btn.bc-btn-catoon.bc-btn-large:hover,
    .bc-btn.bc-btn-catoon.bc-btn-large:active {
      padding: 0 18px;
    }

    .bc-btn.bc-btn-catoon.bc-btn-small .bc-btn-label {
      font-size: 0.82rem;
    }

    .bc-btn.bc-btn-catoon.bc-btn-medium .bc-btn-label {
      font-size: 0.92rem;
    }

    .bc-btn.bc-btn-catoon.bc-btn-large .bc-btn-label {
      font-size: 1.04rem;
    }
  }
  "

def css() -> String:
  base_css() ++ role_css() ++ style_css()
