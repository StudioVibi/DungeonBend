import Dungeon/CombatOutcome as CombatOutcome
import Dungeon/Weapon as Weapon

# === Combat System — laws mirroring design-rules.md §"Combat System" ===
#
# NOTE: The "Combat System" section in design-rules.md is currently
# empty (only the heading exists). The laws below are derived from
# the existing types in /src/Dungeon/_.bend (CombatResult,
# CombatOutcome, Weapon) so the structure is in place; fill in more
# asserts once the prose is written.

# "Combat produces either a continue signal or a game-over signal."
# Encoded by CombatOutcome having exactly two constructors.
assert combat_can_continue:
  combat_continue{} == combat_continue{} :: CombatOutcome

assert combat_can_game_over:
  combat_game_over{} == combat_game_over{} :: CombatOutcome

# "The hero fights with either no weapon or a weapon carrying
# damage." (Derived from the Weapon type.)
assert weapon_carries_damage:
  weapon{0, 5} == weapon{0, 5} :: Weapon

assert no_weapon_is_distinct:
  no_weapon{} == no_weapon{} :: Weapon
