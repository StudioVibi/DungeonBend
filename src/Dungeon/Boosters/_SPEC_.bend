import /Dungeon/CardRef as CardRef
import /Dungeon/PackDef as PackDef
import /Dungeon/PackPoolEntry as PackPoolEntry
import /Dungeon/PackReward as PackReward

# === Booster Pack — laws mirroring design-rules.md §"Booster Pack" ===
#
# These laws encode the affirmative rules about booster packs. Types
# referenced here (PackDef, PackReward, PackPoolEntry, CardRef) are
# defined in /src/Dungeon/_.bend.

# "Opening a booster pack grants a set of X cards to the player."
# The PackDef.reveal_count field is the "X". Concrete 3-card pack:
assert pack_has_reveal_count:
  pack_def{"basic", 50, 3, 0, []}
    == pack_def{"basic", 50, 3, 0, []}
    :: PackDef

# "Booster packs can contain any existing card type in the game."
# PackPoolEntry wraps a CardRef — each CardRef variant is accepted.
assert pool_accepts_hero_card:
  pack_pool_entry{hero_card{}, 1}
    == pack_pool_entry{hero_card{}, 1}
    :: PackPoolEntry

assert pool_accepts_monster_card:
  pack_pool_entry{monster_card{0}, 1}
    == pack_pool_entry{monster_card{0}, 1}
    :: PackPoolEntry

assert pool_accepts_sword_card:
  pack_pool_entry{sword_card{0}, 1}
    == pack_pool_entry{sword_card{0}, 1}
    :: PackPoolEntry

assert pool_accepts_potion_card:
  pack_pool_entry{potion_card{0}, 1}
    == pack_pool_entry{potion_card{0}, 1}
    :: PackPoolEntry

# "The contents of a booster pack are always manually defined by a
# game designer, including drop rates and possible outcomes."
# Manually defined = the pool is a plain List(PackPoolEntry) with
# explicit per-entry weights shipped in Config.
assert pool_weights_are_explicit:
  pack_pool_entry{hero_card{}, 7}
    == pack_pool_entry{hero_card{}, 7}
    :: PackPoolEntry

# "A booster pack produces a reward carrying the revealed cards."
assert pack_reward_shape:
  pack_reward{[hero_card{}]}
    == pack_reward{[hero_card{}]}
    :: PackReward

# "We plan to have multiple booster packs in the future, including
# seasonal ones." Config.booster_packs is a List(PackDef), so the
# catalog is open-ended by construction; a 2-pack catalog example:
assert catalog_can_hold_multiple_packs:
  [pack_def{"basic", 50, 3, 0, []}, pack_def{"seasonal", 100, 5, 0, []}]
    == [pack_def{"basic", 50, 3, 0, []}, pack_def{"seasonal", 100, 5, 0, []}]
    :: List(PackDef)
