import HTML as HTML
import Midum/Button/primary as button_primary
import Midum/Button/secondary as button_secondary

def full_overrides(enabled: U32) -> List(Midum/Button/Override):
  match enabled:
    case 0:
      [width_full{}, state_disabled{}]
    case _:
      [width_full{}]

def fit_overrides(enabled: U32) -> List(Midum/Button/Override):
  match enabled:
    case 0:
      [state_disabled{}]
    case _:
      []

def back_overrides() -> List(Midum/Button/Override):
  [width_fit{}]

def icon_fit_overrides(src: String, enabled: U32) -> List(Midum/Button/Override):
  match enabled:
    case 0:
      [icon_left{src}, shape_square{}, state_disabled{}]
    case _:
      [icon_left{src}, shape_square{}]

def action_wrap(Event: Type, role_class: String, body: HTML(Event)) -> HTML(Event):
  <span class={"db-action-button-wrap " ++ role_class}>
    {body}
  </span>

def primary_full(Event: Type, evt: Event, label: String, enabled: U32) -> HTML(Event):
  action_wrap(
    Event,
    "db-action-button-wrap--primary",
    button_primary(Event, evt, medium{}, label, full_overrides(enabled))
  )

def secondary_full(Event: Type, evt: Event, label: String, enabled: U32) -> HTML(Event):
  action_wrap(
    Event,
    "db-action-button-wrap--secondary",
    button_secondary(Event, evt, medium{}, label, full_overrides(enabled))
  )

def primary_fit(Event: Type, evt: Event, label: String, enabled: U32) -> HTML(Event):
  action_wrap(
    Event,
    "db-action-button-wrap--primary",
    button_primary(Event, evt, medium{}, label, fit_overrides(enabled))
  )

def secondary_fit(Event: Type, evt: Event, label: String, enabled: U32) -> HTML(Event):
  action_wrap(
    Event,
    "db-action-button-wrap--secondary",
    button_secondary(Event, evt, medium{}, label, fit_overrides(enabled))
  )

def secondary_icon_fit(Event: Type, evt: Event, icon_src: String, enabled: U32) -> HTML(Event):
  action_wrap(
    Event,
    "db-action-button-wrap--secondary db-action-button-wrap--icon",
    button_secondary(Event, evt, medium{}, "", icon_fit_overrides(icon_src, enabled))
  )

def back_button(Event: Type, evt: Event, label: String) -> HTML(Event):
  action_wrap(
    Event,
    "db-action-button-wrap--secondary db-action-button-wrap--back",
    button_secondary(Event, evt, medium{}, label, back_overrides())
  )
