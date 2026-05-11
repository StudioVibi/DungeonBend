# Resolved 3x3 perspective-grid cell.
#
# The body is placed in the rectangular content layer. The visual fields style
# the matching SVG trapezoid layer.

type Cell(Event: Type) {
  grid_cell{
    body: HTML(Event),
    trap_border_color: String,
    trap_border_width: Nat,
    trap_fill_color: String,
  }
}
