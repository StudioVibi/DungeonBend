import /U32/ as U32
import /Dungeon/Upgrade as Upgrade
import /Dungeon/Weapon as Weapon
import /Dungeon/Meta as Meta
import /Dungeon/Config as Config
import /Dungeon/Run as Run
import /Dungeon/Scene as Scene
import /Dungeon/config as config
import /Dungeon/Deck/counts_pick/hero_max_hp as hero_max_hp
import /Dungeon/Deck/counts_pick/nth_upgrade as nth_upgrade

def _hero_level(meta_state: Meta) -> U32:
  match meta_state:
    case meta{hero_level, gold}:
      hero_level

def meta_gold(meta_state: Meta) -> String:
  match meta_state:
    case meta{hero_level, gold}:
      U32.show(gold)

def hero_level_text(meta_state: Meta) -> String:
  "Hero Lv " ++ U32.show(_hero_level(meta_state))

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

def phase_badge(scene_value: Scene) -> String:
  match scene_value:
    case setup{}:
      "Idle"
    case running{run_value}:
      "Run Active"
    case game_over{run_value}:
      "Game Over"

def phase_chip_class(scene_value: Scene) -> String:
  match scene_value:
    case setup{}:
      "status-chip status-chip--idle"
    case running{run_value}:
      "status-chip status-chip--active"
    case game_over{run_value}:
      "status-chip status-chip--over"

def dungeon_level_value(scene_value: Scene) -> String:
  match scene_value:
    case setup{}:
      "--"
    case running{run_value}:
      U32.show(_run_dungeon_level(run_value))
    case game_over{run_value}:
      U32.show(_run_dungeon_level(run_value))

def remaining_value(scene_value: Scene) -> String:
  match scene_value:
    case setup{}:
      "--/--"
    case running{run_value}:
      _run_remaining_text(run_value)
    case game_over{run_value}:
      _run_remaining_text(run_value)

def weapon_value(scene_value: Scene) -> String:
  match scene_value:
    case setup{}:
      "--"
    case running{run_value}:
      _run_weapon_text(run_value)
    case game_over{run_value}:
      _run_weapon_text(run_value)

def ultimate_label(scene_value: Scene) -> String:
  match scene_value:
    case setup{}:
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
    case meta{hero_level, gold}:
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
    case config{hero_base_max_hp, upgrades, monsters, swords, potions, deck, base_deck_size, starting_dungeon_level}:
      hero_max_hp(hero_base_max_hp, upgrades, _hero_level(meta_state))

def next_upgrade_cost(meta_state: Meta) -> U32:
  _next_upgrade_cost_from_config(config(), meta_state)

def _next_upgrade_cost_from_config(cfg: Config, meta_state: Meta) -> U32:
  match cfg:
    case config{hero_base_max_hp, upgrades, monsters, swords, potions, deck, base_deck_size, starting_dungeon_level}:
      _upgrade_cost_or_zero(nth_upgrade(upgrades, _hero_level(meta_state)))

def upgrade_label(meta_state: Meta) -> String:
  _upgrade_label_cost(next_upgrade_cost(meta_state))

def _upgrade_label_cost(cost: U32) -> String:
  match cost:
    case 0:
      "Max Level"
    case _:
      "Upgrade - " ++ U32.show(cost)

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
