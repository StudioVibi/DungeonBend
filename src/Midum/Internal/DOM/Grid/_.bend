# Internal DOM renderer for the Midum 3x3 perspective grid.

import HTML as HTML
import Nat/add as nat_add
import Nat/div as nat_div
import Nat/eq as nat_eq
import Nat/ge as nat_ge
import Nat/le as nat_le
import Nat/mul as nat_mul
import Nat/show as show_nat
import Nat/sub as nat_sub

MAX_PERSPECTIVE : Nat = 60n
BASE_ROW_HEIGHT_WEIGHT : Nat = 100n
TOTAL_ROW_HEIGHT_WEIGHT : Nat = 300n
CARD_BASE_WIDTH : Nat = 320n
CARD_BASE_HEIGHT : Nat = 389n
PERSPECTIVE_VANISH_X : Nat = 590n
PERSPECTIVE_VANISH_Y : Nat = 80n
PERSPECTIVE_GUIDE_Y_0 : Nat = 170n
PERSPECTIVE_BOTTOM_X_0 : Nat = 110n
PERSPECTIVE_BOTTOM_X_1 : Nat = 430n
PERSPECTIVE_BOTTOM_X_2 : Nat = 750n
PERSPECTIVE_BOTTOM_X_3 : Nat = 1070n
VIEWBOX_WIDTH : Nat = 1180n
VIEWBOX_BOTTOM_PAD : Nat = 110n

def nat_px(value: Nat) -> String:
  show_nat(value) ++ "px"

def nat_min(a: Nat, b: Nat) -> Nat:
  match nat_le(a, b):
    case true{}:
      a
    case false{}:
      b

def nat_max(a: Nat, b: Nat) -> Nat:
  match nat_ge(a, b):
    case true{}:
      a
    case false{}:
      b

def nat_abs_diff(a: Nat, b: Nat) -> Nat:
  match nat_ge(a, b):
    case true{}:
      nat_sub(a, b)
    case false{}:
      nat_sub(b, a)

def row_height_transfer(amount: Nat, max_transfer: Nat) -> Nat:
  nat_div(nat_mul(max_transfer, amount), MAX_PERSPECTIVE)

def top_row_height_weight(amount: Nat, max_transfer: Nat) -> Nat:
  nat_sub(BASE_ROW_HEIGHT_WEIGHT, row_height_transfer(amount, max_transfer))

def middle_row_height_weight(amount: Nat, max_transfer: Nat) -> Nat:
  BASE_ROW_HEIGHT_WEIGHT

def bottom_row_height_weight(amount: Nat, max_transfer: Nat) -> Nat:
  nat_add(BASE_ROW_HEIGHT_WEIGHT, row_height_transfer(amount, max_transfer))

def row_height_weight(row: Nat, amount: Nat, max_transfer: Nat) -> Nat:
  match row:
    case 0n:
      top_row_height_weight(amount, max_transfer)
    case 1n:
      middle_row_height_weight(amount, max_transfer)
    case _:
      bottom_row_height_weight(amount, max_transfer)

def row_height_weights_str(amount: Nat, max_transfer: Nat) -> String:
  show_nat(top_row_height_weight(amount, max_transfer))
  ++ "/" ++ show_nat(middle_row_height_weight(amount, max_transfer))
  ++ "/" ++ show_nat(bottom_row_height_weight(amount, max_transfer))

def base_grid_height() -> Nat:
  nat_mul(3n, CARD_BASE_HEIGHT)

def total_row_height() -> Nat:
  base_grid_height()

def top_row_height(amount: Nat, max_transfer: Nat) -> Nat:
  nat_div(nat_mul(total_row_height(), top_row_height_weight(amount, max_transfer)), TOTAL_ROW_HEIGHT_WEIGHT)

def middle_row_height(amount: Nat, max_transfer: Nat) -> Nat:
  nat_div(nat_mul(total_row_height(), middle_row_height_weight(amount, max_transfer)), TOTAL_ROW_HEIGHT_WEIGHT)

def bottom_row_height(amount: Nat, max_transfer: Nat) -> Nat:
  nat_sub(total_row_height(), nat_add(top_row_height(amount, max_transfer), middle_row_height(amount, max_transfer)))

def row_height(row: Nat, amount: Nat, max_transfer: Nat) -> Nat:
  match row:
    case 0n:
      top_row_height(amount, max_transfer)
    case 1n:
      middle_row_height(amount, max_transfer)
    case _:
      bottom_row_height(amount, max_transfer)

def row_top_gap(row: Nat, amount: Nat, max_transfer: Nat, gap_y: Nat) -> Nat:
  match nat_ge(gap_y, row_height(row, amount, max_transfer)):
    case true{}:
      row_height(row, amount, max_transfer)
    case false{}:
      gap_y

def guide_y(idx: Nat, amount: Nat, max_transfer: Nat) -> Nat:
  match idx:
    case 0n:
      PERSPECTIVE_GUIDE_Y_0
    case 1n:
      nat_add(PERSPECTIVE_GUIDE_Y_0, row_height(0n, amount, max_transfer))
    case 2n:
      nat_add(PERSPECTIVE_GUIDE_Y_0, nat_add(row_height(0n, amount, max_transfer), row_height(1n, amount, max_transfer)))
    case _:
      nat_add(PERSPECTIVE_GUIDE_Y_0, total_row_height())

def grid_bottom_y() -> Nat:
  nat_add(PERSPECTIVE_GUIDE_Y_0, total_row_height())

def viewbox_height() -> Nat:
  nat_add(grid_bottom_y(), VIEWBOX_BOTTOM_PAD)

def svg_viewbox() -> String:
  "0 0 " ++ show_nat(VIEWBOX_WIDTH) ++ " " ++ show_nat(viewbox_height())

def interp_left(bottom_x: Nat, y: Nat) -> Nat:
  delta_x = nat_sub(PERSPECTIVE_VANISH_X, bottom_x)
  delta_y = nat_sub(y, PERSPECTIVE_VANISH_Y)
  total_y = nat_sub(grid_bottom_y(), PERSPECTIVE_VANISH_Y)
  nat_sub(PERSPECTIVE_VANISH_X, nat_div(nat_mul(delta_x, delta_y), total_y))

def interp_right(bottom_x: Nat, y: Nat) -> Nat:
  delta_x = nat_sub(bottom_x, PERSPECTIVE_VANISH_X)
  delta_y = nat_sub(y, PERSPECTIVE_VANISH_Y)
  total_y = nat_sub(grid_bottom_y(), PERSPECTIVE_VANISH_Y)
  nat_add(PERSPECTIVE_VANISH_X, nat_div(nat_mul(delta_x, delta_y), total_y))

def max_boundary_x(idx: Nat, y: Nat) -> Nat:
  match idx:
    case 0n:
      interp_left(PERSPECTIVE_BOTTOM_X_0, y)
    case 1n:
      interp_left(PERSPECTIVE_BOTTOM_X_1, y)
    case 2n:
      interp_right(PERSPECTIVE_BOTTOM_X_2, y)
    case _:
      interp_right(PERSPECTIVE_BOTTOM_X_3, y)

def flat_boundary_x(idx: Nat) -> Nat:
  match idx:
    case 0n:
      PERSPECTIVE_BOTTOM_X_0
    case 1n:
      PERSPECTIVE_BOTTOM_X_1
    case 2n:
      PERSPECTIVE_BOTTOM_X_2
    case _:
      PERSPECTIVE_BOTTOM_X_3

def lerp_nat(start: Nat, finish: Nat, amount: Nat) -> Nat:
  match nat_ge(finish, start):
    case true{}:
      nat_add(start, nat_div(nat_mul(nat_sub(finish, start), amount), MAX_PERSPECTIVE))
    case false{}:
      nat_sub(start, nat_div(nat_mul(nat_sub(start, finish), amount), MAX_PERSPECTIVE))

def boundary_x(idx: Nat, y: Nat, amount: Nat) -> Nat:
  lerp_nat(flat_boundary_x(idx), max_boundary_x(idx, y), amount)

def point_str(x: Nat, y: Nat) -> String:
  show_nat(x) ++ "," ++ show_nat(y)

def gap_x_01(gap_x: Nat) -> Nat:
  nat_div(gap_x, 2n)

def gap_x_12(gap_x: Nat) -> Nat:
  nat_sub(gap_x, gap_x_01(gap_x))

def left_column_x_shrink(gap_x: Nat) -> Nat:
  nat_div(gap_x, 3n)

def right_column_x_shrink(gap_x: Nat) -> Nat:
  nat_div(nat_add(gap_x, 2n), 3n)

def middle_column_left_inset(gap_x: Nat) -> Nat:
  nat_sub(gap_x_01(gap_x), left_column_x_shrink(gap_x))

def middle_column_right_inset(gap_x: Nat) -> Nat:
  nat_sub(gap_x_12(gap_x), right_column_x_shrink(gap_x))

def col_left_inset(col: Nat, gap_x: Nat) -> Nat:
  match nat_eq(col, 0n):
    case true{}:
      0n
    case false{}:
      match nat_eq(col, 1n):
        case true{}:
          middle_column_left_inset(gap_x)
        case false{}:
          right_column_x_shrink(gap_x)

def col_right_inset(col: Nat, gap_x: Nat) -> Nat:
  match nat_eq(col, 2n):
    case true{}:
      0n
    case false{}:
      match nat_eq(col, 0n):
        case true{}:
          left_column_x_shrink(gap_x)
        case false{}:
          middle_column_right_inset(gap_x)

def cell_id(row: Nat, col: Nat) -> String:
  "r" ++ show_nat(nat_add(row, 1n)) ++ "c" ++ show_nat(nat_add(col, 1n))

def row_top_y(row: Nat, amount: Nat, max_transfer: Nat, gap_y: Nat) -> Nat:
  nat_add(guide_y(row, amount, max_transfer), row_top_gap(row, amount, max_transfer, gap_y))

def row_bottom_y(row: Nat, amount: Nat, max_transfer: Nat) -> Nat:
  guide_y(nat_add(row, 1n), amount, max_transfer)

def cell_top_y(row: Nat, amount: Nat, max_transfer: Nat, gap_y: Nat) -> Nat:
  row_top_y(row, amount, max_transfer, gap_y)

def cell_bottom_y(row: Nat, amount: Nat, max_transfer: Nat) -> Nat:
  row_bottom_y(row, amount, max_transfer)

def cell_boundary_shift(row: Nat, boundary: Nat, amount: Nat, max_transfer: Nat, gap_y: Nat) -> Nat:
  nat_abs_diff(
    boundary_x(boundary, cell_top_y(row, amount, max_transfer, gap_y), amount),
    boundary_x(boundary, cell_bottom_y(row, amount, max_transfer), amount)
  )

def row_min_gap_x(row: Nat, amount: Nat, max_transfer: Nat, gap_y: Nat) -> Nat:
  nat_mul(
    2n,
    nat_max(
      cell_boundary_shift(row, 1n, amount, max_transfer, gap_y),
      cell_boundary_shift(row, 2n, amount, max_transfer, gap_y)
    )
  )

def min_gap_x(amount: Nat, max_transfer: Nat, gap_y: Nat) -> Nat:
  nat_max(
    row_min_gap_x(0n, amount, max_transfer, gap_y),
    nat_max(row_min_gap_x(1n, amount, max_transfer, gap_y), row_min_gap_x(2n, amount, max_transfer, gap_y))
  )

def effective_grid_gap_x(amount: Nat, max_transfer: Nat, gap_y: Nat, gap_x: Nat) -> Nat:
  nat_add(min_gap_x(amount, max_transfer, gap_y), gap_x)

def cell_tl_x(row: Nat, col: Nat, amount: Nat, gap_x: Nat, max_transfer: Nat, gap_y: Nat) -> Nat:
  top_y = cell_top_y(row, amount, max_transfer, gap_y)
  nat_add(boundary_x(col, top_y, amount), col_left_inset(col, gap_x))

def cell_tr_x(row: Nat, col: Nat, amount: Nat, gap_x: Nat, max_transfer: Nat, gap_y: Nat) -> Nat:
  top_y = cell_top_y(row, amount, max_transfer, gap_y)
  nat_sub(boundary_x(nat_add(col, 1n), top_y, amount), col_right_inset(col, gap_x))

def cell_br_x(row: Nat, col: Nat, amount: Nat, gap_x: Nat, max_transfer: Nat) -> Nat:
  bot_y = cell_bottom_y(row, amount, max_transfer)
  nat_sub(boundary_x(nat_add(col, 1n), bot_y, amount), col_right_inset(col, gap_x))

def cell_bl_x(row: Nat, col: Nat, amount: Nat, gap_x: Nat, max_transfer: Nat) -> Nat:
  bot_y = cell_bottom_y(row, amount, max_transfer)
  nat_add(boundary_x(col, bot_y, amount), col_left_inset(col, gap_x))

def cell_points(row: Nat, col: Nat, amount: Nat, gap_x: Nat, max_transfer: Nat, gap_y: Nat) -> String:
  top_y = cell_top_y(row, amount, max_transfer, gap_y)
  bot_y = cell_bottom_y(row, amount, max_transfer)
  tl_x = cell_tl_x(row, col, amount, gap_x, max_transfer, gap_y)
  tr_x = cell_tr_x(row, col, amount, gap_x, max_transfer, gap_y)
  br_x = cell_br_x(row, col, amount, gap_x, max_transfer)
  bl_x = cell_bl_x(row, col, amount, gap_x, max_transfer)
  point_str(tl_x, top_y) ++ " " ++ point_str(tr_x, top_y) ++ " " ++ point_str(br_x, bot_y) ++ " " ++ point_str(bl_x, bot_y)

def cell_shape(amount: Nat) -> String:
  match nat_eq(amount, 0n):
    case true{}:
      "rect"
    case false{}:
      "trapezoid"

def grid_box_left() -> Nat:
  PERSPECTIVE_BOTTOM_X_0

def grid_box_top() -> Nat:
  PERSPECTIVE_GUIDE_Y_0

def grid_box_width() -> Nat:
  nat_sub(PERSPECTIVE_BOTTOM_X_3, PERSPECTIVE_BOTTOM_X_0)

def grid_box_height() -> Nat:
  total_row_height()

def content_row_top(row: Nat, amount: Nat, max_transfer: Nat) -> Nat:
  nat_sub(guide_y(row, amount, max_transfer), grid_box_top())

def content_row_left_abs(row: Nat, amount: Nat, max_transfer: Nat) -> Nat:
  boundary_x(0n, row_bottom_y(row, amount, max_transfer), amount)

def content_row_right_abs(row: Nat, amount: Nat, max_transfer: Nat) -> Nat:
  boundary_x(3n, row_bottom_y(row, amount, max_transfer), amount)

def content_row_left(row: Nat, amount: Nat, max_transfer: Nat) -> Nat:
  nat_sub(content_row_left_abs(row, amount, max_transfer), grid_box_left())

def content_row_width(row: Nat, amount: Nat, max_transfer: Nat) -> Nat:
  nat_sub(content_row_right_abs(row, amount, max_transfer), content_row_left_abs(row, amount, max_transfer))

def content_rect_left_abs(row: Nat, col: Nat, amount: Nat, gap_x: Nat, max_transfer: Nat, gap_y: Nat) -> Nat:
  nat_min(
    cell_tl_x(row, col, amount, gap_x, max_transfer, gap_y),
    cell_bl_x(row, col, amount, gap_x, max_transfer)
  )

def content_rect_right_abs(row: Nat, col: Nat, amount: Nat, gap_x: Nat, max_transfer: Nat, gap_y: Nat) -> Nat:
  nat_max(
    cell_tr_x(row, col, amount, gap_x, max_transfer, gap_y),
    cell_br_x(row, col, amount, gap_x, max_transfer)
  )

def content_rect_left(row: Nat, col: Nat, amount: Nat, gap_x: Nat, max_transfer: Nat, gap_y: Nat) -> Nat:
  nat_sub(content_rect_left_abs(row, col, amount, gap_x, max_transfer, gap_y), content_row_left_abs(row, amount, max_transfer))

def content_rect_width(row: Nat, col: Nat, amount: Nat, gap_x: Nat, max_transfer: Nat, gap_y: Nat) -> Nat:
  nat_sub(
    content_rect_right_abs(row, col, amount, gap_x, max_transfer, gap_y),
    content_rect_left_abs(row, col, amount, gap_x, max_transfer, gap_y)
  )

def ratio_css(value: Nat, total: Nat) -> String:
  "calc((100% * " ++ show_nat(value) ++ ") / " ++ show_nat(total) ++ ")"

def content_bounds_label(bounds: Midum/Grid/ContentBounds) -> String:
  match bounds:
    case hidden{}:
      "hidden"
    case visible{}:
      "visible"

def content_bounds_border(bounds: Midum/Grid/ContentBounds, alpha: String) -> String:
  match bounds:
    case hidden{}:
      "rgba(72, 160, 255, 0)"
    case visible{}:
      "rgba(72, 160, 255, " ++ alpha ++ ")"

def cell_index(row: Nat, col: Nat) -> Nat:
  nat_add(nat_mul(row, 3n), col)

def default_cell(Event: Type) -> Midum/Grid/Cell(Event):
  grid_cell{body: text{""}, trap_border_color: "#ffffff", trap_border_width: 1n, trap_fill_color: "transparent"}

def cell_or_default(Event: Type, cells: List(Midum/Grid/Cell(Event)), idx: Nat) -> Midum/Grid/Cell(Event):
  match cells idx:
    case [] 0n:
      default_cell(Event)
    case head<>tail 0n:
      head
    case [] 1n+rest:
      default_cell(Event)
    case _<>tail 1n+rest:
      cell_or_default(Event, tail, rest)

def trap_border_color(Event: Type, cell: Midum/Grid/Cell(Event)) -> String:
  match cell:
    case grid_cell{body, trap_border_color, trap_border_width, trap_fill_color}:
      trap_border_color

def trap_border_width(Event: Type, cell: Midum/Grid/Cell(Event)) -> Nat:
  match cell:
    case grid_cell{body, trap_border_color, trap_border_width, trap_fill_color}:
      trap_border_width

def trap_fill_color(Event: Type, cell: Midum/Grid/Cell(Event)) -> String:
  match cell:
    case grid_cell{body, trap_border_color, trap_border_width, trap_fill_color}:
      trap_fill_color

def cell_body(Event: Type, cell: Midum/Grid/Cell(Event)) -> HTML(Event):
  match cell:
    case grid_cell{body, trap_border_color, trap_border_width, trap_fill_color}:
      body

def perspective_cell(Event: Type, row: Nat, col: Nat, cell: Midum/Grid/Cell(Event), amount: Nat, gap_x: Nat, max_transfer: Nat, gap_y: Nat) -> HTML(Event):
  points = cell_points(row, col, amount, gap_x, max_transfer, gap_y);
  <g
    data-grid-cell="cell"
    data-cell-shape={cell_shape(amount)}
    data-row={show_nat(nat_add(row, 1n))}
    data-col={show_nat(nat_add(col, 1n))}
    data-perspective-id={cell_id(row, col)}
  >
    <polygon
      points={points}
      fill={trap_fill_color(Event, cell)}
      data-trap-fill-color={trap_fill_color(Event, cell)}
    />
    <polygon
      points={points}
      fill="none"
      stroke={trap_border_color(Event, cell)}
      data-trap-border-color={trap_border_color(Event, cell)}
      data-trap-border-width={show_nat(trap_border_width(Event, cell))}
      style:stroke-width={nat_px(trap_border_width(Event, cell))}
      style:stroke-linejoin="round"
      style:vector-effect="non-scaling-stroke"
    />
  </g>

def perspective_row(Event: Type, row: Nat, cells: List(Midum/Grid/Cell(Event)), amount: Nat, gap_x: Nat, max_transfer: Nat, gap_y: Nat) -> HTML(Event):
  <g
    data-grid-row="row"
    data-row={show_nat(nat_add(row, 1n))}
    data-row-height-weight={show_nat(row_height_weight(row, amount, max_transfer))}
  >
    {perspective_cell(Event, row, 0n, cell_or_default(Event, cells, cell_index(row, 0n)), amount, gap_x, max_transfer, gap_y)}
    {perspective_cell(Event, row, 1n, cell_or_default(Event, cells, cell_index(row, 1n)), amount, gap_x, max_transfer, gap_y)}
    {perspective_cell(Event, row, 2n, cell_or_default(Event, cells, cell_index(row, 2n)), amount, gap_x, max_transfer, gap_y)}
  </g>

def perspective_svg(Event: Type, cells: List(Midum/Grid/Cell(Event)), amount: Nat, gap_x: Nat, max_transfer: Nat, gap_y: Nat) -> HTML(Event):
  <svg
    class="bc-grid-svg"
    data-layer="2"
    data-perspective-svg="scene"
    data-perspective-horizon="center-high"
    data-perspective-amount={show_nat(amount)}
    data-grid-gap-x={show_nat(gap_x)}
    data-grid-gap-y={show_nat(gap_y)}
    data-row-height-weights={row_height_weights_str(amount, max_transfer)}
    data-max-transfer={show_nat(max_transfer)}
    viewBox={svg_viewbox()}
    preserveAspectRatio="xMidYMid meet"
  >
    {perspective_row(Event, 0n, cells, amount, gap_x, max_transfer, gap_y)}
    {perspective_row(Event, 1n, cells, amount, gap_x, max_transfer, gap_y)}
    {perspective_row(Event, 2n, cells, amount, gap_x, max_transfer, gap_y)}
  </svg>

def content_cell(Event: Type, bounds: Midum/Grid/ContentBounds, row: Nat, col: Nat, cell: Midum/Grid/Cell(Event), amount: Nat, gap_x: Nat, max_transfer: Nat, gap_y: Nat) -> HTML(Event):
  <div
    class="bc-grid-content-cell"
    data-content-cell="cell"
    data-content-row={show_nat(nat_add(row, 1n))}
    data-content-col={show_nat(nat_add(col, 1n))}
    data-content-bounds={content_bounds_label(bounds)}
    data-content-shape="rect"
    data-content-height-mode="row"
    data-content-width-mode="white-trapezoid-bounds"
    style:top="0%"
    style:height="100%"
    style:left={ratio_css(content_rect_left(row, col, amount, gap_x, max_transfer, gap_y), content_row_width(row, amount, max_transfer))}
    style:width={ratio_css(content_rect_width(row, col, amount, gap_x, max_transfer, gap_y), content_row_width(row, amount, max_transfer))}
    style:border={"2px solid " ++ content_bounds_border(bounds, "0.98")}
  >
    <div class="bc-grid-content-cell-inner">
      {cell_body(Event, cell)}
    </div>
  </div>

def content_row(Event: Type, bounds: Midum/Grid/ContentBounds, row: Nat, cells: List(Midum/Grid/Cell(Event)), amount: Nat, gap_x: Nat, max_transfer: Nat, gap_y: Nat) -> HTML(Event):
  <div
    class="bc-grid-content-row"
    data-content-row-shell="row"
    data-content-row={show_nat(nat_add(row, 1n))}
    data-content-bounds={content_bounds_label(bounds)}
    style:left={ratio_css(content_row_left(row, amount, max_transfer), grid_box_width())}
    style:top={ratio_css(content_row_top(row, amount, max_transfer), grid_box_height())}
    style:width={ratio_css(content_row_width(row, amount, max_transfer), grid_box_width())}
    style:height={ratio_css(row_height(row, amount, max_transfer), grid_box_height())}
    style:border={"1px solid " ++ content_bounds_border(bounds, "0.58")}
  >
    {content_cell(Event, bounds, row, 0n, cell_or_default(Event, cells, cell_index(row, 0n)), amount, gap_x, max_transfer, gap_y)}
    {content_cell(Event, bounds, row, 1n, cell_or_default(Event, cells, cell_index(row, 1n)), amount, gap_x, max_transfer, gap_y)}
    {content_cell(Event, bounds, row, 2n, cell_or_default(Event, cells, cell_index(row, 2n)), amount, gap_x, max_transfer, gap_y)}
  </div>

def content_layer(Event: Type, bounds: Midum/Grid/ContentBounds, cells: List(Midum/Grid/Cell(Event)), amount: Nat, gap_x: Nat, max_transfer: Nat, gap_y: Nat) -> HTML(Event):
  <div
    class="bc-grid-content-layer"
    data-layer="3"
    data-content-layer="content"
    data-content-parent="grid-box"
    data-content-bounds={content_bounds_label(bounds)}
    data-perspective-amount={show_nat(amount)}
    data-grid-gap-x={show_nat(gap_x)}
    data-grid-gap-y={show_nat(gap_y)}
    style:left={ratio_css(grid_box_left(), VIEWBOX_WIDTH)}
    style:top={ratio_css(grid_box_top(), viewbox_height())}
    style:width={ratio_css(grid_box_width(), VIEWBOX_WIDTH)}
    style:height={ratio_css(grid_box_height(), viewbox_height())}
    style:border={"1px solid " ++ content_bounds_border(bounds, "0.34")}
  >
    {content_row(Event, bounds, 0n, cells, amount, gap_x, max_transfer, gap_y)}
    {content_row(Event, bounds, 1n, cells, amount, gap_x, max_transfer, gap_y)}
    {content_row(Event, bounds, 2n, cells, amount, gap_x, max_transfer, gap_y)}
  </div>

def render(Event: Type, cells: List(Midum/Grid/Cell(Event)), cfg: Midum/Grid/Config) -> HTML(Event):
  match cfg:
    case grid{perspective, grid_gap_x, grid_gap_y, max_transfer, content_bounds}:
      effective_gap_x = effective_grid_gap_x(perspective, max_transfer, grid_gap_y, grid_gap_x);
      <div
        class="bc-grid"
        data-grid="perspective-grid"
        data-perspective-method="flat-to-trapezoid-svg"
        data-perspective-scope="midum"
        data-perspective-amount={show_nat(perspective)}
        data-grid-gap-x={show_nat(grid_gap_x)}
        data-grid-gap-x-min={show_nat(min_gap_x(perspective, max_transfer, grid_gap_y))}
        data-grid-gap-x-effective={show_nat(effective_gap_x)}
        data-grid-gap-y={show_nat(grid_gap_y)}
        data-row-height-weights={row_height_weights_str(perspective, max_transfer)}
        data-max-transfer={show_nat(max_transfer)}
        data-content-bounds={content_bounds_label(content_bounds)}
      >
        {perspective_svg(Event, cells, perspective, effective_gap_x, max_transfer, grid_gap_y)}
        {content_layer(Event, content_bounds, cells, perspective, effective_gap_x, max_transfer, grid_gap_y)}
      </div>
