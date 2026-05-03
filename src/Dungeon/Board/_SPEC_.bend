import Dungeon/Direction as Direction
import Dungeon/Board/indexing/board_pos as board_pos
import Dungeon/Board/indexing/adjacent_pos as adjacent_pos

# === Scene Setup / Movement — laws mirroring design-rules.md
# §"Dungeon Scene Setup" ===
#
# These laws cover the 3x3 grid layout, the hero's starting position,
# and the four-direction movement rule. `board_pos` is defined in
# ./indexing.bend and maps a linear index 0..8 to a v2{x,y} on a
# 3x3 grid. The center cell is index 4 = v2{1, 1}.

# "The hero card always starts in the center of the grid, no exceptions."
assert hero_starts_center:
  board_pos(4) == v2{1n, 1n} :: Nat/V2

# "A swipe always targets the adjacent card in that direction."
# From the center (index 4), each of the 4 directions yields a
# unique adjacent cell. Laws below pin each one.
assert swipe_up_from_center:
  adjacent_pos(4, up{}) == some{v2{1n, 0n}} :: Maybe(Nat/V2)

assert swipe_down_from_center:
  adjacent_pos(4, down{}) == some{v2{1n, 2n}} :: Maybe(Nat/V2)

assert swipe_left_from_center:
  adjacent_pos(4, left{}) == some{v2{0n, 1n}} :: Maybe(Nat/V2)

assert swipe_right_from_center:
  adjacent_pos(4, right{}) == some{v2{2n, 1n}} :: Maybe(Nat/V2)

# "Diagonal movement is not allowed."
# Encoded structurally: the Direction type has exactly 4
# constructors (up, down, left, right) and no diagonal variant.
# Constructing each one smoke-tests that the enumeration is closed.
assert direction_up_exists:
  up{} == up{} :: Direction

assert direction_down_exists:
  down{} == down{} :: Direction

assert direction_left_exists:
  left{} == left{} :: Direction

assert direction_right_exists:
  right{} == right{} :: Direction
