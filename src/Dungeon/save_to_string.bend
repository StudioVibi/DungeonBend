import /U32/ as U32
import /Dungeon/CardRef as CardRef
import /Dungeon/PackReward as PackReward
import /Dungeon/Scene as Scene
import /Dungeon/GameState as GameState
import /Dungeon/UiState as UiState
import /Dungeon/DungeonState as DungeonState
import /Dungeon/meta_to_string as meta_to_string

def save_to_string(state: DungeonState) -> String:
  match state:
    case dungeon{game_state{meta_state, scene_value, next_seed}, ui_value}:
      String/join(
        [
          meta_to_string(meta_state),
          _saved_scene_kind(scene_value),
          _saved_scene_reward(scene_value),
          _saved_scene_index(scene_value)
        ],
        "|"
      )

def _saved_scene_kind(scene_value: Scene) -> String:
  match scene_value:
    case boosters{reward, reveal_index}:
      "1"
    case _:
      "0"

def _saved_scene_reward(scene_value: Scene) -> String:
  match scene_value:
    case boosters{reward, reveal_index}:
      _reward_to_string(reward)
    case _:
      ""

def _saved_scene_index(scene_value: Scene) -> String:
  match scene_value:
    case boosters{reward, reveal_index}:
      U32.show(reveal_index)
    case _:
      "0"

def _reward_to_string(reward: PackReward) -> String:
  match reward:
    case no_pack_reward{}:
      ""
    case pack_reward{cards}:
      String/join(_reward_codes(cards), ",")

def _reward_codes(cards: List(CardRef)) -> List(String):
  match cards:
    case []:
      []
    case card<>rest:
      U32.show(_card_code(card))<>_reward_codes(rest)

def _card_code(card: CardRef) -> U32:
  match card:
    case monster_card{ref}:
      1000 + ref
    case sword_card{ref}:
      2000 + ref
    case potion_card{ref}:
      3000 + ref
    case hero_card{}:
      4000
