import /dungeon/data/config as config
import /dungeon/logic/Meta
import /dungeon/logic/Run/upgrade_hero as upgrade_hero

def _eq_u32(a: U32, b: U32) -> U32:
  match a === b:
    case 0:
      0
    case _:
      1

def _assert_upgrade_pair(affordable: Meta, blocked: Meta) -> U32:
  match affordable:
    case meta{level_a, gold_a}:
      match blocked:
        case meta{level_b, gold_b}:
          _eq_u32(level_a, 1)
          * _eq_u32(gold_a, 5)
          * _eq_u32(level_b, 0)
          * _eq_u32(gold_b, 5)

def main() -> U32:
  _assert_upgrade_pair(
    upgrade_hero(config(), meta{0, 25}),
    upgrade_hero(config(), meta{0, 5})
  )

def test_upgrade_hero() -> U32:
  main()
