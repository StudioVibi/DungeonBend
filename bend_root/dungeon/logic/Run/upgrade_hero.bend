import /dungeon/logic/Config
import /dungeon/logic/Meta
import /dungeon/logic/Upgrade
import /dungeon/logic/Deck/nth_upgrade as nth_upgrade

def _upgrade_if_affordable(hero_level: U32, gold_value: U32, meta_state: Meta, cost: U32) -> Meta:
  match gold_value < cost:
    case 0:
      (meta{hero_level + 1, gold_value - cost} :: Meta)
    case _:
      (meta_state :: Meta)

def _upgrade_from_step(hero_level: U32, gold_value: U32, meta_state: Meta, step: Upgrade) -> Meta:
  match step:
    case upgrade{cost, max_hp}:
      match max_hp === 0:
        case 0:
          _upgrade_if_affordable(hero_level, gold_value, meta_state, cost)
        case _:
          meta_state

def upgrade_hero(config_value: Config, meta_state: Meta) -> Meta:
  match config_value meta_state:
    case config{hero_base_max_hp, upgrades, monsters, swords, potions, deck, base_deck_size, starting_dungeon_level} meta{hero_level, gold_value}:
      _upgrade_from_step(hero_level, gold_value, meta{hero_level, gold_value}, nth_upgrade(upgrades, hero_level))
