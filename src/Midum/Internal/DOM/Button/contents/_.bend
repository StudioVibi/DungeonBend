# Internal button content renderer.

import HTML as HTML

def left_icon(Event: Type, icon: Midum/Button/Icon) -> HTML(Event):
  match icon:
    case left{src}:
      <img class="bc-btn-icon" src={src} alt="" />
    case off{}:
      text{""}
    case right{src}:
      text{""}

def right_icon(Event: Type, icon: Midum/Button/Icon) -> HTML(Event):
  match icon:
    case right{src}:
      <img class="bc-btn-icon" src={src} alt="" />
    case off{}:
      text{""}
    case left{src}:
      text{""}

def contents(Event: Type, label: String, icon: Midum/Button/Icon) -> HTML(Event):
  <span class="bc-btn-content">
    {left_icon(Event, icon)}
    <span class="bc-btn-label">{text{label}}</span>
    {right_icon(Event, icon)}
  </span>
