# Internal DOM button renderer for Midum.
#
# This module stays as the thin role boundary while helpers and CSS live in
# smaller sibling modules.

import HTML as HTML
import Midum/Internal/DOM/Button/base_css as button_base_css
import Midum/Internal/DOM/Button/catoon_css as button_catoon_css
import Midum/Internal/DOM/Button/render_resolved as render_resolved
import Midum/Internal/DOM/Button/render_resolved_with_count as render_resolved_with_count
import Midum/Internal/DOM/Button/role_css as button_role_css
import Midum/Internal/DOM/Button/style_css as button_style_css

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

def catoon_yellow(Event: Type, evt: Event, cfg: Midum/Button/Config) -> HTML(Event):
  wrapped_button(Event, evt, cfg, "bc-btn-catoon-wrap bc-btn-catoon-wrap--yellow", "bc-btn-primary bc-btn-catoon bc-btn-catoon--yellow")

def catoon_dark(Event: Type, evt: Event, cfg: Midum/Button/Config) -> HTML(Event):
  wrapped_button(Event, evt, cfg, "bc-btn-catoon-wrap bc-btn-catoon-wrap--dark", "bc-btn-secondary bc-btn-catoon bc-btn-catoon--dark")

def catoon_dark_counter(Event: Type, evt: Event, cfg: Midum/Button/Config, count: String) -> HTML(Event):
  <span class="bc-btn-catoon-wrap bc-btn-catoon-wrap--dark">
    {button_with_count(Event, evt, cfg, "bc-btn-secondary bc-btn-catoon bc-btn-catoon--dark bc-btn-catoon-count", count)}
  </span>

def catoon(Event: Type, evt: Event, cfg: Midum/Button/Config) -> HTML(Event):
  catoon_yellow(Event, evt, cfg)

def catoon_secondary(Event: Type, evt: Event, cfg: Midum/Button/Config) -> HTML(Event):
  catoon_dark(Event, evt, cfg)

def button(Event: Type, evt: Event, cfg: Midum/Button/Config, role_class: String) -> HTML(Event):
  match cfg:
    case button{text, icon, shape, size, width, state}:
      render_resolved(Event, evt, role_class, text, icon, shape, size, width, state)

def button_with_count(Event: Type, evt: Event, cfg: Midum/Button/Config, role_class: String, count: String) -> HTML(Event):
  match cfg:
    case button{text, icon, shape, size, width, state}:
      render_resolved_with_count(Event, evt, role_class, text, icon, shape, size, width, state, count)

def wrapped_button(Event: Type, evt: Event, cfg: Midum/Button/Config, wrap_class: String, role_class: String) -> HTML(Event):
  <span class={wrap_class}>
    {button(Event, evt, cfg, role_class)}
  </span>

def css() -> String:
  button_base_css() ++ button_role_css() ++ button_style_css() ++ button_catoon_css()
