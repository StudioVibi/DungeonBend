import /Dungeon/Upgrade as Upgrade
import /Dungeon/MonsterDef as MonsterDef
import /Dungeon/SwordDef as SwordDef
import /Dungeon/PotionDef as PotionDef
import /Dungeon/DeckEntry as DeckEntry
import /Dungeon/Weapon as Weapon
import /Dungeon/Tile as Tile
import /Dungeon/Board as Board
import /Dungeon/BoardDraw as BoardDraw
import /Dungeon/DrawResult as DrawResult
import /Dungeon/CombatResult as CombatResult
import /Dungeon/Meta as Meta
import /Dungeon/Config as Config
import /Dungeon/Run as Run
import /Dungeon/SwipeResult as SwipeResult
import /Dungeon/RunSlot as RunSlot
import /Dungeon/DungeonEvent as DungeonEvent
import /Dungeon/DungeonState as DungeonState
import /Dungeon/ImpactState as ImpactState
import /Dungeon/_PickResult as _PickResult
import /Dungeon/Board/indexing/board_get as board_get
import /Dungeon/Board/indexing/board_set as board_set
import /Dungeon/Board/indexing/_back_index as _back_index

def _shift_after_move_back(board_value: Board, board1: Board, hero_index: U32, back: U32, spawn: Tile) -> Board:
  match back === 9:
    case 0:
      back_tile = board_get(board_value, back);
      board2 = board_set(board1, hero_index, back_tile);
      board_set(board2, back, spawn)
    case _:
      board_set(board1, hero_index, spawn)

def shift_after_move(
  board_value: Board,
  hero_index: U32,
  target_index: U32,
  dir: U32,
  spawn: Tile,
) -> Board:
  _shift_after_move_back(
    board_value,
    board_set(board_value, target_index, none{}),
    hero_index,
    _back_index(hero_index, dir),
    spawn
  )
