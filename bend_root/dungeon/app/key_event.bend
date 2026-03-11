import /dungeon/app/DungeonEvent

def key_event(key: U32) -> DungeonEvent:
  match key:
    case 37:
      turn_left{}
    case 65:
      turn_left{}
    case 38:
      turn_up{}
    case 87:
      turn_up{}
    case 39:
      turn_right{}
    case 68:
      turn_right{}
    case 40:
      turn_down{}
    case 83:
      turn_down{}
    case 32:
      restart{}
    case 82:
      restart{}
    case _:
      ignore{}
