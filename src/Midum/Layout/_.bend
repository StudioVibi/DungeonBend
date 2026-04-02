# Public layout API for Midum.
#
# Layout stays separate from component authoring. It starts with positioning and
# now also supports simple grouping through flow and gap.

import /HTML/
import /Midum/Layout/Config
import /Midum/Layout/Flow
import /Midum/Layout/Gap
import /Midum/Internal/DOM/Layout/box as dom_box
import /Midum/Internal/DOM/Layout/overlay as dom_overlay
import /Midum/Internal/DOM/Layout/stack as dom_stack

def overlay(Event: Type, layers: List(HTML(Event))) -> HTML(Event):
  dom_overlay(Event, layers)

def top_left(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: top_left{}, flow: column{}, gap: none{}}, body)

def top(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: top{}, flow: column{}, gap: none{}}, body)

def top_right(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: top_right{}, flow: column{}, gap: none{}}, body)

def left(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: left{}, flow: column{}, gap: none{}}, body)

def center(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: center{}, flow: column{}, gap: none{}}, body)

def right(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: right{}, flow: column{}, gap: none{}}, body)

def bottom_left(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: bottom_left{}, flow: column{}, gap: none{}}, body)

def bottom(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: bottom{}, flow: column{}, gap: none{}}, body)

def bottom_right(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: bottom_right{}, flow: column{}, gap: none{}}, body)

def column(Event: Type, kids: List(HTML(Event))) -> HTML(Event):
  dom_stack(Event, column{}, md{}, kids)

def row(Event: Type, kids: List(HTML(Event))) -> HTML(Event):
  dom_stack(Event, row{}, md{}, kids)
