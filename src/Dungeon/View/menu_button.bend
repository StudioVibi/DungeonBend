import HTML as HTML
import Dungeon/DungeonEvent as DungeonEvent

def disabled_class(enabled: U32) -> String:
  match enabled:
    case 0:
      " menu-main-button--disabled"
    case _:
      ""

def button_class(tone_class: String, size_class: String, enabled: U32) -> String:
  "bc-btn menu-main-button " ++ tone_class ++ " " ++ size_class ++ disabled_class(enabled)

def button_body(label: String) -> HTML(DungeonEvent):
  <span class="menu-main-button__content">
    <span class="menu-main-button__label">{text{label}}</span>
  </span>

def button(evt: DungeonEvent, label: String, tone_class: String, size_class: String, enabled: U32) -> HTML(DungeonEvent):
  match enabled:
    case 0:
      <button class={button_class(tone_class, size_class, enabled)} type="button" disabled="disabled">
        {button_body(label)}
      </button>
    case _:
      <button class={button_class(tone_class, size_class, enabled)} type="button" on_click={evt}>
        {button_body(label)}
      </button>

def primary(evt: DungeonEvent, label: String, enabled: U32) -> HTML(DungeonEvent):
  button(evt, label, "menu-main-button--primary", "menu-main-button--large", enabled)

def secondary(evt: DungeonEvent, label: String, enabled: U32) -> HTML(DungeonEvent):
  button(evt, label, "menu-main-button--secondary", "menu-main-button--medium", enabled)
