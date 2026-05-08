# Shared resolved button DOM branch.

import HTML as HTML
import Midum/Internal/DOM/Button/button_class as button_class
import Midum/Internal/DOM/Button/contents as contents

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
