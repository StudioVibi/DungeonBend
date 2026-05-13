import HTML as HTML
import Midum/Button/catoon_dark as button_catoon_dark
import Midum/Button/catoon_yellow as button_catoon_yellow

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

def icon_fit_overrides(src: String, enabled: U32) -> List(Midum/Button/Override):
  match enabled:
    case 0:
      [icon_left{src}, shape_square{}, state_disabled{}]
    case _:
      [icon_left{src}, shape_square{}]

def primary_full(Event: Type, evt: Event, label: String, enabled: U32) -> HTML(Event):
  button_catoon_yellow(Event, evt, medium{}, label, full_overrides(enabled))

def secondary_full(Event: Type, evt: Event, label: String, enabled: U32) -> HTML(Event):
  button_catoon_dark(Event, evt, medium{}, label, full_overrides(enabled))

def primary_fit(Event: Type, evt: Event, label: String, enabled: U32) -> HTML(Event):
  button_catoon_yellow(Event, evt, medium{}, label, fit_overrides(enabled))

def secondary_fit(Event: Type, evt: Event, label: String, enabled: U32) -> HTML(Event):
  button_catoon_dark(Event, evt, medium{}, label, fit_overrides(enabled))

def secondary_icon_fit(Event: Type, evt: Event, icon_src: String, enabled: U32) -> HTML(Event):
  button_catoon_dark(Event, evt, medium{}, "", icon_fit_overrides(icon_src, enabled))

def back_button(Event: Type, evt: Event, label: String) -> HTML(Event):
  button_catoon_dark(Event, evt, small{}, label, fit_overrides(1))
