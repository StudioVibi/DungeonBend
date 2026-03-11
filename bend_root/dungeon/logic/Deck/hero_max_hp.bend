import /dungeon/logic/Upgrade
import /dungeon/logic/Deck/nth_upgrade as nth_upgrade

def _from_upgrade(step: Upgrade, fallback: U32) -> U32:
  match step:
    case upgrade{cost, max_hp}:
      match max_hp === 0:
        case 0:
          max_hp
        case _:
          fallback

def hero_max_hp(base_hp: U32, upgrades: List(Upgrade), hero_level: U32) -> U32:
  match hero_level === 0:
    case 0:
      _from_upgrade(nth_upgrade(upgrades, hero_level - 1), base_hp)
    case _:
      base_hp
