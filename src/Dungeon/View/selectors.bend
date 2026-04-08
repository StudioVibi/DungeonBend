import /U32/ as U32
import /Dungeon/Upgrade as Upgrade
import /Dungeon/HeroDef as HeroDef
import /Dungeon/PackDef as PackDef
import /Dungeon/PackReward as PackReward
import /Dungeon/Weapon as Weapon
import /Dungeon/Meta as Meta
import /Dungeon/Config as Config
import /Dungeon/Run as Run
import /Dungeon/Scene as Scene
import /Dungeon/config as config
import /Dungeon/Deck/counts_pick/hero_max_hp as hero_max_hp
import /Dungeon/Deck/counts_pick/nth_upgrade as nth_upgrade
import /Dungeon/Boosters/inventory/pack_inventory_count as pack_inventory_count
import /Dungeon/Boosters/inventory/pack_inventory_total as pack_inventory_total
import /Dungeon/Boosters/packs/active_pack as active_pack
import /Dungeon/Boosters/reward_nav/reward_count as reward_count

def _hero_level(meta_state: Meta) -> U32:
  match meta_state:
    case meta{hero_level, gold, bonus_deck, pack_inventory}:
      hero_level

def meta_gold(meta_state: Meta) -> String:
  match meta_state:
    case meta{hero_level, gold, bonus_deck, pack_inventory}:
      U32.show(gold)

def meta_pack_total(meta_state: Meta) -> String:
  match meta_state:
    case meta{hero_level, gold, bonus_deck, pack_inventory}:
      U32.show(pack_inventory_total(pack_inventory))

def hero_level_text(meta_state: Meta) -> String:
  "Hero Lv " ++ U32.show(_hero_level(meta_state))

def hero_display_level(meta_state: Meta) -> String:
  U32.show(_hero_level(meta_state) + 1)

def hero_menu_stats(meta_state: Meta) -> String:
  hp = U32.show(hero_max_hp_value(meta_state));
  "LV: " ++ hero_display_level(meta_state) ++ "   HP: " ++ hp ++ "/" ++ hp

def _run_dungeon_level(run_value: Run) -> U32:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, ult_charge}:
      dungeon_level

def _run_remaining_text(run_value: Run) -> String:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, ult_charge}:
      U32.show(remaining) ++ "/" ++ U32.show(capacity)

def _weapon_value_from_weapon(weapon_value: Weapon) -> String:
  match weapon_value:
    case no_weapon{}:
      "Unarmed"
    case weapon{ref, dmg}:
      "DMG " ++ U32.show(dmg)

def _run_weapon_text(run_value: Run) -> String:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, ult_charge}:
      _weapon_value_from_weapon(weapon)

def _run_ult_label(run_value: Run) -> String:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, ult_charge}:
      "ULTIMATE " ++ U32.show(ult_charge) ++ "/6"

def _run_ult_ready(run_value: Run) -> U32:
  match run_value:
    case run{dungeon_level, hero_hp, hero_max_hp, hero_index, weapon, board_value, deck_blueprint, draw_counts, remaining, capacity, seed, ult_charge}:
      match ult_charge:
        case 6:
          1
        case _:
          0

def dungeon_level_value(scene_value: Scene) -> String:
  match scene_value:
    case setup{}:
      "--"
    case boosters{reward, reveal_index}:
      "--"
    case running{run_value}:
      U32.show(_run_dungeon_level(run_value))
    case game_over{run_value}:
      U32.show(_run_dungeon_level(run_value))

def remaining_value(scene_value: Scene) -> String:
  match scene_value:
    case setup{}:
      "--/--"
    case boosters{reward, reveal_index}:
      "--/--"
    case running{run_value}:
      _run_remaining_text(run_value)
    case game_over{run_value}:
      _run_remaining_text(run_value)

def weapon_value(scene_value: Scene) -> String:
  match scene_value:
    case setup{}:
      "--"
    case boosters{reward, reveal_index}:
      "--"
    case running{run_value}:
      _run_weapon_text(run_value)
    case game_over{run_value}:
      _run_weapon_text(run_value)

def ultimate_label(scene_value: Scene) -> String:
  match scene_value:
    case setup{}:
      "ULTIMATE 0/6"
    case boosters{reward, reveal_index}:
      "ULTIMATE 0/6"
    case running{run_value}:
      _run_ult_label(run_value)
    case game_over{run_value}:
      _run_ult_label(run_value)

def ultimate_enabled(scene_value: Scene) -> U32:
  match scene_value:
    case running{run_value}:
      _run_ult_ready(run_value)
    case _:
      0

def start_enabled(scene_value: Scene) -> U32:
  match scene_value:
    case setup{}:
      1
    case _:
      0

def can_upgrade(scene_value: Scene) -> U32:
  start_enabled(scene_value)

def _can_afford_upgrade_gold(gold: U32, cost: U32) -> U32:
  match cost:
    case 0:
      0
    case _:
      _can_afford_upgrade_flag(gold < cost)

def _can_afford_upgrade_flag(gold_lt_cost: U32) -> U32:
  match gold_lt_cost:
    case 0:
      1
    case _:
      0

def can_afford_upgrade(meta_state: Meta, cost: U32) -> U32:
  match meta_state:
    case meta{hero_level, gold, bonus_deck, pack_inventory}:
      _can_afford_upgrade_gold(gold, cost)

def upgrade_enabled(meta_state: Meta, scene_value: Scene, cost: U32) -> U32:
  _upgrade_enabled_flag(can_upgrade(scene_value), can_afford_upgrade(meta_state, cost))

def _upgrade_enabled_flag(can_upgrade_value: U32, can_afford_value: U32) -> U32:
  match can_upgrade_value:
    case 0:
      0
    case _:
      can_afford_value

def _upgrade_cost_or_zero(step: Upgrade) -> U32:
  match step:
    case upgrade{cost, max_hp}:
      match max_hp:
        case 0:
          0
        case _:
          cost

def hero_max_hp_value(meta_state: Meta) -> U32:
  _hero_max_hp_from_config(config(), meta_state)

def _hero_max_hp_from_config(cfg: Config, meta_state: Meta) -> U32:
  match cfg:
    case config{hero, upgrades, monsters, swords, potions, deck, booster_packs, starting_dungeon_level}:
      _hero_max_hp_from_def(hero, upgrades, meta_state)

def _hero_max_hp_from_def(hero_value: HeroDef, upgrades: List(Upgrade), meta_state: Meta) -> U32:
  match hero_value:
    case hero_def{name, sprite, base_max_hp}:
      hero_max_hp(base_max_hp, upgrades, _hero_level(meta_state))

def next_upgrade_cost(meta_state: Meta) -> U32:
  _next_upgrade_cost_from_config(config(), meta_state)

def _next_upgrade_cost_from_config(cfg: Config, meta_state: Meta) -> U32:
  match cfg:
    case config{hero, upgrades, monsters, swords, potions, deck, booster_packs, starting_dungeon_level}:
      _upgrade_cost_or_zero(nth_upgrade(upgrades, _hero_level(meta_state)))

def upgrade_label(meta_state: Meta) -> String:
  _upgrade_label_cost(next_upgrade_cost(meta_state))

def _upgrade_label_cost(cost: U32) -> String:
  match cost:
    case 0:
      "Max Level"
    case _:
      "Upgrade - " ++ U32.show(cost)

def menu_upgrade_label(meta_state: Meta) -> String:
  _menu_upgrade_label_cost(next_upgrade_cost(meta_state))

def _menu_upgrade_label_cost(cost: U32) -> String:
  match cost:
    case 0:
      "MAX LEVEL"
    case _:
      "UPGRADE"

def menu_upgrade_cost_text(meta_state: Meta) -> String:
  _menu_upgrade_cost_text(next_upgrade_cost(meta_state))

def _menu_upgrade_cost_text(cost: U32) -> String:
  match cost:
    case 0:
      "MAX"
    case _:
      U32.show(cost)

def board_shell_class(scene_value: Scene) -> String:
  match scene_value:
    case game_over{run_value}:
      "board-shell board-shell--over"
    case _:
      "board-shell"

def game_over_modal_class(scene_value: Scene) -> String:
  match scene_value:
    case game_over{run_value}:
      "game-over-modal game-over-modal--visible"
    case _:
      "game-over-modal"

def active_pack_name() -> String:
  _pack_name(active_pack(config()))

def _pack_name(pack: PackDef) -> String:
  match pack:
    case pack_def{name, price, reveal_count, allow_duplicates, pool}:
      name

def active_pack_price() -> U32:
  _pack_price(active_pack(config()))

def _pack_price(pack: PackDef) -> U32:
  match pack:
    case pack_def{name, price, reveal_count, allow_duplicates, pool}:
      price

def active_pack_reveal_count() -> String:
  _pack_reveal_count(active_pack(config()))

def _pack_reveal_count(pack: PackDef) -> String:
  match pack:
    case pack_def{name, price, reveal_count, allow_duplicates, pool}:
      U32.show(reveal_count)

def active_pack_owned(meta_state: Meta) -> U32:
  match meta_state:
    case meta{hero_level, gold, bonus_deck, pack_inventory}:
      pack_inventory_count(pack_inventory, 0)

def active_pack_owned_text(meta_state: Meta) -> String:
  U32.show(active_pack_owned(meta_state))

def booster_buy_enabled(meta_state: Meta) -> U32:
  _can_afford_upgrade_gold(_meta_gold_value(meta_state), active_pack_price())

def booster_open_enabled(meta_state: Meta) -> U32:
  _booster_open_enabled(active_pack_owned(meta_state))

def _booster_open_enabled(owned: U32) -> U32:
  match owned:
    case 0:
      0
    case _:
      1

def _meta_gold_value(meta_state: Meta) -> U32:
  match meta_state:
    case meta{hero_level, gold, bonus_deck, pack_inventory}:
      gold

def booster_prev_enabled(reveal_index: U32) -> U32:
  match reveal_index:
    case 0:
      0
    case _:
      1

def booster_next_enabled(reward: PackReward, reveal_index: U32) -> U32:
  _booster_next_enabled(reward_count(reward), reveal_index)

def _booster_next_enabled(count: U32, reveal_index: U32) -> U32:
  match count:
    case 0:
      0
    case _:
      _booster_next_enabled_match(reveal_index + 1 < count)

def _booster_next_enabled_match(enabled: U32) -> U32:
  match enabled:
    case 0:
      0
    case _:
      1

def booster_reward_position_text(reward: PackReward, reveal_index: U32) -> String:
  _booster_reward_position_text(reward_count(reward), reveal_index)

def _booster_reward_position_text(count: U32, reveal_index: U32) -> String:
  match count:
    case 0:
      ""
    case _:
      U32.show(reveal_index + 1) ++ "/" ++ U32.show(count)
