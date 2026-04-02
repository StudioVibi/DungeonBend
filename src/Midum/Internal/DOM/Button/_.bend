# Internal DOM button renderer for Midum.
#
# This module maps concrete inline button{...} values to the current DOM
# renderer and theme tracks.

import /HTML/

def primary(Event: Type, evt: Event, cfg: Midum/Button/Config) -> HTML(Event):
  button(Event, evt, cfg, "bc-btn-primary")

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

# Final DOM branch once inline fields have already been resolved.
def render_resolved(Event: Type, evt: Event, role_class: String, label: String, icon: Midum/Button/Icon, shape: Midum/Button/Shape, size: Midum/Button/Size, width: Midum/Button/Width, state: Midum/Button/State) -> HTML(Event):
  match state:
    case disabled{}:
      <button class={button_class(role_class, icon, shape, size, width, state)} type="button" disabled="disabled">
        {contents(Event, label, icon)}
      </button>
    case enabled{}:
      <button class={button_class(role_class, icon, shape, size, width, state)} type="button" on_click={evt}>
        {contents(Event, label, icon)}
      </button>

# One shared renderer for primary / secondary / danger with concrete inline
# values only.
def button(Event: Type, evt: Event, cfg: Midum/Button/Config, role_class: String) -> HTML(Event):
  match cfg:
    case button{text, icon, shape, size, width, state}:
      render_resolved(Event, evt, role_class, text, icon, shape, size, width, state)

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
  "

def css() -> String:
  base_css() ++ role_css() ++ style_css()
