# Public text API for Midum.
#
# Text stays renderer-neutral. The current renderer lives under
# /Midum/Internal/DOM/.

import HTML
import Midum/Text/Interaction
import Midum/Internal/DOM/Text/render as dom_render
def apply_override(Event: Type, cfg: Midum/Text/Config(Event), override: Midum/Text/Override(Event)) -> Midum/Text/Config(Event):
  match cfg override:
    case copy{content, variant, align, interaction, color} link{href}:
      copy{content, variant, align, interaction: navigate{href}, color}
    case copy{content, variant, align, interaction, color} action{evt}:
      copy{content, variant, align, interaction: trigger{evt}, color}
    case copy{content, variant, align, interaction, color} color_primary{}:
      copy{content, variant, align, interaction, color: primary{}}
    case copy{content, variant, align, interaction, color} color_secondary{}:
      copy{content, variant, align, interaction, color: secondary{}}
    case copy{content, variant, align, interaction, color} color_neutral{}:
      copy{content, variant, align, interaction, color: neutral{}}
    case copy{content, variant, align, interaction, color} color_success{}:
      copy{content, variant, align, interaction, color: success{}}
    case copy{content, variant, align, interaction, color} color_warning{}:
      copy{content, variant, align, interaction, color: warning{}}
    case copy{content, variant, align, interaction, color} color_danger{}:
      copy{content, variant, align, interaction, color: danger{}}

def apply_overrides(Event: Type, cfg: Midum/Text/Config(Event), overrides: List(Midum/Text/Override(Event))) -> Midum/Text/Config(Event):
  match overrides:
    case []:
      cfg
    case override<>rest:
      apply_overrides(Event, apply_override(Event, cfg, override), rest)

def config(Event: Type, variant: Midum/Text/Variant, align: Midum/Text/Align, content: String, overrides: List(Midum/Text/Override(Event))) -> Midum/Text/Config(Event):
  apply_overrides(Event, copy{content, variant, align, interaction: static{}, color: inherited{}}, overrides)

def label(Event: Type, align: Midum/Text/Align, content: String, overrides: List(Midum/Text/Override(Event))) -> HTML(Event):
  dom_render(Event, config(Event, label{}, align, content, overrides))

def h1(Event: Type, align: Midum/Text/Align, content: String, overrides: List(Midum/Text/Override(Event))) -> HTML(Event):
  dom_render(Event, config(Event, heading_1{}, align, content, overrides))

def h2(Event: Type, align: Midum/Text/Align, content: String, overrides: List(Midum/Text/Override(Event))) -> HTML(Event):
  dom_render(Event, config(Event, heading_2{}, align, content, overrides))

def body(Event: Type, align: Midum/Text/Align, content: String, overrides: List(Midum/Text/Override(Event))) -> HTML(Event):
  dom_render(Event, config(Event, body{}, align, content, overrides))
