# Internal button class helpers for the DOM renderer.

def shape_class(shape: Midum/Button/Shape) -> String:
  match shape:
    case square{}:
      "bc-btn-square"
    case rounded{}:
      "bc-btn-rounded"

def size_class(size: Midum/Button/Size) -> String:
  match size:
    case small{}:
      "bc-btn-small"
    case medium{}:
      "bc-btn-medium"
    case large{}:
      "bc-btn-large"

def width_class(width: Midum/Button/Width) -> String:
  match width:
    case fit{}:
      "bc-btn-fit"
    case wide{}:
      "bc-btn-wide"
    case full{}:
      "bc-btn-full"

def icon_class(icon: Midum/Button/Icon) -> String:
  match icon:
    case left{src}:
      "bc-btn-icon-left"
    case right{src}:
      "bc-btn-icon-right"
    case off{}:
      ""

def state_class(state: Midum/Button/State) -> String:
  match state:
    case disabled{}:
      "bc-btn-disabled"
    case enabled{}:
      ""

def button_class(role_class: String, icon: Midum/Button/Icon, shape: Midum/Button/Shape, size: Midum/Button/Size, width: Midum/Button/Width, state: Midum/Button/State) -> String:
  "bc-btn " ++ role_class ++ " " ++ shape_class(shape) ++ " " ++ size_class(size) ++ " " ++ width_class(width) ++ " " ++ icon_class(icon) ++ " " ++ state_class(state)
