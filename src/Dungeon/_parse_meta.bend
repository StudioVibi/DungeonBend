import /String/ as String
import /Dungeon/DungeonEvent as DungeonEvent
import /Dungeon/Config as Config
import /Dungeon/MonsterDef as MonsterDef
import /Dungeon/SwordDef as SwordDef
import /Dungeon/PotionDef as PotionDef
import /Dungeon/PackDef as PackDef
import /Dungeon/DeckEntry as DeckEntry
import /Dungeon/CardRef as CardRef
import /Dungeon/PackReward as PackReward
import /Dungeon/PackInventoryEntry as PackInventoryEntry
import /Dungeon/SavedScene as SavedScene
import /Dungeon/config as config
import /Dungeon/Boosters/reward_nav/reward_count as reward_count

def _parse_meta(s: String) -> DungeonEvent:
  _parse_sections(String/split(s, '|'))

def _parse_sections(parts: List(String)) -> DungeonEvent:
  match parts:
    case legacy<>rest:
      match rest:
        case []:
          _parse_legacy_parts(String/split(legacy, ','))
        case gold_str<>rest1:
          match rest1:
            case monster_str<>rest2:
              match rest2:
                case sword_str<>rest3:
                  match rest3:
                    case potion_str<>rest4:
                      match rest4:
                        case pack_str<>rest5:
                          match rest5:
                            case []:
                              _parse_profile(
                                config(),
                                String/to_u32(legacy),
                                String/to_u32(gold_str),
                                String/split(monster_str, ','),
                                String/split(sword_str, ','),
                                String/split(potion_str, ','),
                                String/split(pack_str, ','),
                                saved_setup{}
                              )
                            case scene_kind_str<>rest6:
                              match rest6:
                                case reward_str<>rest7:
                                  match rest7:
                                    case reveal_index_str<>rest8:
                                      match rest8:
                                        case []:
                                          _parse_profile(
                                            config(),
                                            String/to_u32(legacy),
                                            String/to_u32(gold_str),
                                            String/split(monster_str, ','),
                                            String/split(sword_str, ','),
                                            String/split(potion_str, ','),
                                            String/split(pack_str, ','),
                                            _parse_saved_scene(
                                              String/to_u32(scene_kind_str),
                                              String/split(reward_str, ','),
                                              String/to_u32(reveal_index_str)
                                            )
                                          )
                                        case _:
                                          no_save{}
                                    case _:
                                      no_save{}
                                case _:
                                  no_save{}
                            case _:
                              no_save{}
                        case _:
                          no_save{}
                    case _:
                      no_save{}
                case _:
                  no_save{}
            case _:
              no_save{}
        case _:
          no_save{}
    case _:
      no_save{}

def _parse_legacy_parts(parts: List(String)) -> DungeonEvent:
  match parts:
    case hl_str<>rest:
      match rest:
        case gold_str<>rest1:
          match rest1:
            case []:
              _parse_legacy_values(String/to_u32(hl_str), String/to_u32(gold_str))
            case _:
              no_save{}
        case _:
          no_save{}
    case _:
      no_save{}

def _parse_legacy_values(hl_maybe: Maybe(U32), gold_maybe: Maybe(U32)) -> DungeonEvent:
  match hl_maybe gold_maybe:
    case some{hl_val} some{g_val}:
      loaded{meta{hl_val, g_val, [], []}, saved_setup{}}
    case _:
      no_save{}

def _parse_profile(config_value: Config, hl_maybe: Maybe(U32), gold_maybe: Maybe(U32), monster_counts: List(String), sword_counts: List(String), potion_counts: List(String), pack_counts: List(String), saved_scene: SavedScene) -> DungeonEvent:
  match config_value hl_maybe gold_maybe:
    case config{hero, upgrades, monsters, swords, potions, deck, booster_packs, starting_dungeon_level} some{hl_val} some{g_val}:
      loaded{
        meta{
          hl_val,
          g_val,
          _merge_bonus_sections(
            _parse_monster_bonus(monsters, monster_counts, 0),
            _parse_sword_bonus(swords, sword_counts, 0),
            _parse_potion_bonus(potions, potion_counts, 0)
          ),
          _parse_pack_inventory(booster_packs, pack_counts, 0)
        },
        saved_scene
      }
    case _:
      no_save{}

def _merge_bonus_sections(monsters: List(DeckEntry), swords: List(DeckEntry), potions: List(DeckEntry)) -> List(DeckEntry):
  _append_bonus(monsters, _append_bonus(swords, potions))

def _append_bonus(left: List(DeckEntry), right: List(DeckEntry)) -> List(DeckEntry):
  match left:
    case []:
      right
    case entry<>rest:
      entry<>_append_bonus(rest, right)

def _count_from_head(parts: List(String)) -> U32:
  match parts:
    case []:
      0
    case head<>rest:
      _count_from_maybe(String/to_u32(head))

def _count_from_maybe(count_maybe: Maybe(U32)) -> U32:
  match count_maybe:
    case some{count}:
      count
    case none{}:
      0

def _tail_parts(parts: List(String)) -> List(String):
  match parts:
    case []:
      []
    case head<>rest:
      rest

def _parse_monster_bonus(monsters: List(MonsterDef), counts: List(String), idx: U32) -> List(DeckEntry):
  match monsters:
    case []:
      []
    case monster_def{name, sprite, gold_drop, hp_levels}<>rest:
      _monster_bonus_entry(
        _count_from_head(counts),
        idx,
        _parse_monster_bonus(rest, _tail_parts(counts), idx + 1)
      )

def _monster_bonus_entry(count: U32, idx: U32, rest: List(DeckEntry)) -> List(DeckEntry):
  match count:
    case 0:
      rest
    case _:
      monster_entry{idx, count}<>rest

def _parse_sword_bonus(swords: List(SwordDef), counts: List(String), idx: U32) -> List(DeckEntry):
  match swords:
    case []:
      []
    case sword_def{name, sprite, dmg}<>rest:
      _sword_bonus_entry(
        _count_from_head(counts),
        idx,
        _parse_sword_bonus(rest, _tail_parts(counts), idx + 1)
      )

def _sword_bonus_entry(count: U32, idx: U32, rest: List(DeckEntry)) -> List(DeckEntry):
  match count:
    case 0:
      rest
    case _:
      sword_entry{idx, count}<>rest

def _parse_potion_bonus(potions: List(PotionDef), counts: List(String), idx: U32) -> List(DeckEntry):
  match potions:
    case []:
      []
    case potion_def{name, sprite, heal}<>rest:
      _potion_bonus_entry(
        _count_from_head(counts),
        idx,
        _parse_potion_bonus(rest, _tail_parts(counts), idx + 1)
      )

def _potion_bonus_entry(count: U32, idx: U32, rest: List(DeckEntry)) -> List(DeckEntry):
  match count:
    case 0:
      rest
    case _:
      potion_entry{idx, count}<>rest

def _parse_pack_inventory(packs: List(PackDef), counts: List(String), idx: U32) -> List(PackInventoryEntry):
  match packs:
    case []:
      []
    case pack_def{name, price, reveal_count, allow_duplicates, pool}<>rest:
      _pack_inventory_entry(
        _count_from_head(counts),
        idx,
        _parse_pack_inventory(rest, _tail_parts(counts), idx + 1)
      )

def _pack_inventory_entry(count: U32, idx: U32, rest: List(PackInventoryEntry)) -> List(PackInventoryEntry):
  match count:
    case 0:
      rest
    case _:
      pack_inventory_entry{idx, count}<>rest

def _parse_saved_scene(scene_kind_maybe: Maybe(U32), reward_parts: List(String), reveal_index_maybe: Maybe(U32)) -> SavedScene:
  match scene_kind_maybe:
    case some{scene_kind}:
      _parse_saved_scene_kind(scene_kind === 1, reward_parts, reveal_index_maybe)
    case none{}:
      saved_setup{}

def _parse_saved_scene_kind(is_boosters: U32, reward_parts: List(String), reveal_index_maybe: Maybe(U32)) -> SavedScene:
  match is_boosters:
    case 0:
      saved_setup{}
    case _:
      reward = _parse_saved_reward(reward_parts);
      saved_boosters{reward, _saved_reveal_index(reward, reveal_index_maybe)}

def _parse_saved_reward(parts: List(String)) -> PackReward:
  _reward_from_cards(_parse_saved_reward_cards(parts))

def _reward_from_cards(cards: List(CardRef)) -> PackReward:
  match cards:
    case []:
      no_pack_reward{}
    case card<>rest:
      pack_reward{cards}

def _parse_saved_reward_cards(parts: List(String)) -> List(CardRef):
  match parts:
    case []:
      []
    case head<>rest:
      _append_reward_card(_parse_card_code(String/to_u32(head)), _parse_saved_reward_cards(rest))

def _append_reward_card(card_maybe: Maybe(CardRef), rest: List(CardRef)) -> List(CardRef):
  match card_maybe:
    case some{card}:
      card<>rest
    case none{}:
      rest

def _parse_card_code(code_maybe: Maybe(U32)) -> Maybe(CardRef):
  match code_maybe:
    case some{code}:
      _parse_card_code_value(code)
    case none{}:
      none{}

def _parse_card_code_value(code: U32) -> Maybe(CardRef):
  _parse_hero_code(code === 4000, code)

def _parse_hero_code(is_hero: U32, code: U32) -> Maybe(CardRef):
  match is_hero:
    case 0:
      _parse_potion_code(code >= 3000, code)
    case _:
      some{hero_card{}}

def _parse_potion_code(is_potion: U32, code: U32) -> Maybe(CardRef):
  match is_potion:
    case 0:
      _parse_sword_code(code >= 2000, code)
    case _:
      some{potion_card{code - 3000}}

def _parse_sword_code(is_sword: U32, code: U32) -> Maybe(CardRef):
  match is_sword:
    case 0:
      _parse_monster_code(code >= 1000, code)
    case _:
      some{sword_card{code - 2000}}

def _parse_monster_code(is_monster: U32, code: U32) -> Maybe(CardRef):
  match is_monster:
    case 0:
      none{}
    case _:
      some{monster_card{code - 1000}}

def _saved_reveal_index(reward: PackReward, reveal_index_maybe: Maybe(U32)) -> U32:
  _saved_reveal_index_from_count(reward_count(reward), reveal_index_maybe)

def _saved_reveal_index_from_count(count: U32, reveal_index_maybe: Maybe(U32)) -> U32:
  match count reveal_index_maybe:
    case 0 some{idx}:
      0
    case 0 none{}:
      0
    case count some{idx}:
      _saved_reveal_index_match(idx < count, idx, count)
    case count none{}:
      0

def _saved_reveal_index_match(in_range: U32, idx: U32, count: U32) -> U32:
  match in_range:
    case 0:
      count - 1
    case _:
      idx
