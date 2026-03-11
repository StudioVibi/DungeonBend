import /dungeon/logic/Upgrade

def nth_upgrade(upgrades: List(Upgrade), idx: U32) -> Upgrade:
  match upgrades:
    case []:
      upgrade{0, 0}
    case upgrade{cost, max_hp}<>rest:
      match idx === 0:
        case 0:
          nth_upgrade(rest, idx - 1)
        case _:
          upgrade{cost, max_hp}
