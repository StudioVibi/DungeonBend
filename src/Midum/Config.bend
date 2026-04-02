# Project-global Midum setup.
#
# Edit this file once to choose the app-wide visual system.

def palette() -> Midum/Theme/Palette:
  olive{}

def style() -> Midum/Theme/Style:
  toon{}

# Button defaults stay project-global, but individual button calls may still
# grow local overrides later without changing the theme layer.
def button_defaults() -> Midum/Button/Defaults:
  defaults{icon: off{}, shape: rounded{}, width: fit{}, state: enabled{}}

# Card defaults stay project-global, while background, border, and gradient
# remain implicit surface behavior and can still be overridden per instance.
def card_defaults() -> Midum/Card/Defaults:
  defaults{padding: md{}, radius: rounded{}}
