# Public 3x3 perspective-grid API for Midum.
#
# Cells are provided in row-major order: r1c1, r1c2, r1c3, r2c1...

import HTML as HTML
import Midum/Internal/DOM/Grid/render as dom_render
import Nat/compare as compare_nat

MAX_PERSPECTIVE : Nat = 60n
MAX_TRANSFER : Nat = 60n

def nat_ge(left: Nat, right: Nat) -> Bool:
  match compare_nat(left, right):
    case lt{}:
      false{}
    case _:
      true{}

def clamp(max_value: Nat, value: Nat) -> Nat:
  match nat_ge(value, max_value):
    case true{}:
      max_value
    case false{}:
      value

def with_perspective(cfg: Midum/Grid/Config, value: Nat) -> Midum/Grid/Config:
  match cfg:
    case grid{perspective, grid_gap_x, grid_gap_y, max_transfer, content_bounds}:
      grid{perspective: clamp(MAX_PERSPECTIVE, value), grid_gap_x, grid_gap_y, max_transfer, content_bounds}

def with_gap_x(cfg: Midum/Grid/Config, value: Nat) -> Midum/Grid/Config:
  match cfg:
    case grid{perspective, grid_gap_x, grid_gap_y, max_transfer, content_bounds}:
      grid{perspective, grid_gap_x: value, grid_gap_y, max_transfer, content_bounds}

def with_gap_y(cfg: Midum/Grid/Config, value: Nat) -> Midum/Grid/Config:
  match cfg:
    case grid{perspective, grid_gap_x, grid_gap_y, max_transfer, content_bounds}:
      grid{perspective, grid_gap_x, grid_gap_y: value, max_transfer, content_bounds}

def with_max_transfer(cfg: Midum/Grid/Config, value: Nat) -> Midum/Grid/Config:
  match cfg:
    case grid{perspective, grid_gap_x, grid_gap_y, max_transfer, content_bounds}:
      grid{perspective, grid_gap_x, grid_gap_y, max_transfer: clamp(MAX_TRANSFER, value), content_bounds}

def with_content_bounds(cfg: Midum/Grid/Config, value: Midum/Grid/ContentBounds) -> Midum/Grid/Config:
  match cfg:
    case grid{perspective, grid_gap_x, grid_gap_y, max_transfer, content_bounds}:
      grid{perspective, grid_gap_x, grid_gap_y, max_transfer, content_bounds: value}

def apply_override(cfg: Midum/Grid/Config, override: Midum/Grid/Override) -> Midum/Grid/Config:
  match override:
    case perspective{value}:
      with_perspective(cfg, value)
    case grid_gap_x{value}:
      with_gap_x(cfg, value)
    case grid_gap_y{value}:
      with_gap_y(cfg, value)
    case max_transfer{value}:
      with_max_transfer(cfg, value)
    case content_bounds_visible{}:
      with_content_bounds(cfg, visible{})
    case content_bounds_hidden{}:
      with_content_bounds(cfg, hidden{})

def apply_overrides(cfg: Midum/Grid/Config, overrides: List(Midum/Grid/Override)) -> Midum/Grid/Config:
  match overrides:
    case []:
      cfg
    case override<>rest:
      apply_overrides(apply_override(cfg, override), rest)

def config(overrides: List(Midum/Grid/Override)) -> Midum/Grid/Config:
  apply_overrides(grid{perspective: 15n, grid_gap_x: 0n, grid_gap_y: 110n, max_transfer: 35n, content_bounds: hidden{}}, overrides)

def apply_cell_override(Event: Type, cfg: Midum/Grid/Cell(Event), override: Midum/Grid/CellOverride) -> Midum/Grid/Cell(Event):
  match cfg override:
    case grid_cell{body, trap_border_color, trap_border_width, trap_fill_color} trap_border_color{value}:
      grid_cell{body, trap_border_color: value, trap_border_width, trap_fill_color}
    case grid_cell{body, trap_border_color, trap_border_width, trap_fill_color} trap_border_width_px{value}:
      grid_cell{body, trap_border_color, trap_border_width: value, trap_fill_color}
    case grid_cell{body, trap_border_color, trap_border_width, trap_fill_color} trap_fill_color{value}:
      grid_cell{body, trap_border_color, trap_border_width, trap_fill_color: value}

def apply_cell_overrides(Event: Type, cfg: Midum/Grid/Cell(Event), overrides: List(Midum/Grid/CellOverride)) -> Midum/Grid/Cell(Event):
  match overrides:
    case []:
      cfg
    case override<>rest:
      apply_cell_overrides(Event, apply_cell_override(Event, cfg, override), rest)

def cell(Event: Type, body: HTML(Event), overrides: List(Midum/Grid/CellOverride)) -> Midum/Grid/Cell(Event):
  apply_cell_overrides(Event, grid_cell{body, trap_border_color: "#ffffff", trap_border_width: 1n, trap_fill_color: "transparent"}, overrides)

def empty(Event: Type) -> Midum/Grid/Cell(Event):
  cell(Event, text{""}, [])

def view(Event: Type, cells: List(Midum/Grid/Cell(Event)), overrides: List(Midum/Grid/Override)) -> HTML(Event):
  dom_render(Event, cells, config(overrides))
