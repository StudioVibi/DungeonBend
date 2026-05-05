# Public button API for Midum.
#
# The public surface stays renderer-neutral. The current renderer lives under
# /Midum/Internal/DOM/.

import HTML as HTML
import Midum/Config/button_defaults as current_button_defaults
import Midum/Internal/DOM/Button/catoon as dom_catoon
import Midum/Internal/DOM/Button/catoon_secondary as dom_catoon_secondary
import Midum/Internal/DOM/Button/primary as dom_primary
import Midum/Internal/DOM/Button/neutral as dom_neutral
import Midum/Internal/DOM/Button/secondary as dom_secondary
import Midum/Internal/DOM/Button/success as dom_success
import Midum/Internal/DOM/Button/warning as dom_warning
import Midum/Internal/DOM/Button/danger as dom_danger

def apply_override(cfg: Midum/Button/Config, override: Midum/Button/Override) -> Midum/Button/Config:
  match cfg override:
    case button{text, icon, shape, size, width, state, catoon_palette: palette_value} icon_off{}:
      button{text, icon: off{}, shape, size, width, state, catoon_palette: palette_value}
    case button{text, icon, shape, size, width, state, catoon_palette: palette_value} icon_left{src}:
      button{text, icon: left{src}, shape, size, width, state, catoon_palette: palette_value}
    case button{text, icon, shape, size, width, state, catoon_palette: palette_value} icon_right{src}:
      button{text, icon: right{src}, shape, size, width, state, catoon_palette: palette_value}
    case button{text, icon, shape, size, width, state, catoon_palette: palette_value} shape_square{}:
      button{text, icon, shape: square{}, size, width, state, catoon_palette: palette_value}
    case button{text, icon, shape, size, width, state, catoon_palette: palette_value} shape_rounded{}:
      button{text, icon, shape: rounded{}, size, width, state, catoon_palette: palette_value}
    case button{text, icon, shape, size, width, state, catoon_palette: palette_value} width_fit{}:
      button{text, icon, shape, size, width: fit{}, state, catoon_palette: palette_value}
    case button{text, icon, shape, size, width, state, catoon_palette: palette_value} width_wide{}:
      button{text, icon, shape, size, width: wide{}, state, catoon_palette: palette_value}
    case button{text, icon, shape, size, width, state, catoon_palette: palette_value} width_full{}:
      button{text, icon, shape, size, width: full{}, state, catoon_palette: palette_value}
    case button{text, icon, shape, size, width, state, catoon_palette: palette_value} state_enabled{}:
      button{text, icon, shape, size, width, state: enabled{}, catoon_palette: palette_value}
    case button{text, icon, shape, size, width, state, catoon_palette: palette_value} state_disabled{}:
      button{text, icon, shape, size, width, state: disabled{}, catoon_palette: palette_value}
    case button{text, icon, shape, size, width, state, catoon_palette: palette_value} catoon_palette{light, mid, dark}:
      button{text, icon, shape, size, width, state, catoon_palette: some{palette{light, mid, dark}}}

def apply_overrides(cfg: Midum/Button/Config, overrides: List(Midum/Button/Override)) -> Midum/Button/Config:
  match overrides:
    case []:
      cfg
    case override<>rest:
      apply_overrides(apply_override(cfg, override), rest)

def config_with_defaults(defaults: Midum/Button/Defaults, text: String, size: Midum/Button/Size, overrides: List(Midum/Button/Override)) -> Midum/Button/Config:
  match defaults:
    case defaults{icon, shape, width, state}:
      apply_overrides(button{text, icon, shape, size, width, state, catoon_palette: none{}}, overrides)

def config(text: String, size: Midum/Button/Size, overrides: List(Midum/Button/Override)) -> Midum/Button/Config:
  config_with_defaults(current_button_defaults(), text, size, overrides)

def primary(Event: Type, evt: Event, size: Midum/Button/Size, text: String, overrides: List(Midum/Button/Override)) -> HTML(Event):
  dom_primary(Event, evt, config(text, size, overrides))

def catoon(Event: Type, evt: Event, size: Midum/Button/Size, text: String, overrides: List(Midum/Button/Override)) -> HTML(Event):
  dom_catoon(Event, evt, config(text, size, overrides))

def catoon_secondary(Event: Type, evt: Event, size: Midum/Button/Size, text: String, overrides: List(Midum/Button/Override)) -> HTML(Event):
  dom_catoon_secondary(Event, evt, config(text, size, overrides))

def secondary(Event: Type, evt: Event, size: Midum/Button/Size, text: String, overrides: List(Midum/Button/Override)) -> HTML(Event):
  dom_secondary(Event, evt, config(text, size, overrides))

def neutral(Event: Type, evt: Event, size: Midum/Button/Size, text: String, overrides: List(Midum/Button/Override)) -> HTML(Event):
  dom_neutral(Event, evt, config(text, size, overrides))

def success(Event: Type, evt: Event, size: Midum/Button/Size, text: String, overrides: List(Midum/Button/Override)) -> HTML(Event):
  dom_success(Event, evt, config(text, size, overrides))

def warning(Event: Type, evt: Event, size: Midum/Button/Size, text: String, overrides: List(Midum/Button/Override)) -> HTML(Event):
  dom_warning(Event, evt, config(text, size, overrides))

def danger(Event: Type, evt: Event, size: Midum/Button/Size, text: String, overrides: List(Midum/Button/Override)) -> HTML(Event):
  dom_danger(Event, evt, config(text, size, overrides))
