import /dungeon/logic/MonsterDef

def monster_gold(monsters: List(MonsterDef), idx: U32) -> U32:
  match monsters:
    case []:
      0
    case monster_def{gold_drop, hp_levels}<>rest:
      match idx === 0:
        case 0:
          monster_gold(rest, idx - 1)
        case _:
          gold_drop
