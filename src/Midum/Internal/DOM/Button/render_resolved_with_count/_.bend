# Shared resolved button DOM branch with an inline count badge.

import HTML as HTML
import Midum/Internal/DOM/Button/button_class as button_class
import Midum/Internal/DOM/Button/contents_with_count as contents_with_count

def render_resolved_with_count(Event: Type, evt: Event, role_class: String, label: String, icon: Midum/Button/Icon, shape: Midum/Button/Shape, size: Midum/Button/Size, width: Midum/Button/Width, state: Midum/Button/State, count: String) -> HTML(Event):
  match state:
    case disabled{}:
      <button class={button_class(role_class, icon, shape, size, width, state)} type="button" disabled="disabled">
        {contents_with_count(Event, label, icon, count)}
      </button>
    case enabled{}:
      <button class={button_class(role_class, icon, shape, size, width, state)} type="button" on_click={evt}>
        {contents_with_count(Event, label, icon, count)}
      </button>
