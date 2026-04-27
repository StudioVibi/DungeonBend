import U32 as U32
import Dungeon/Meta as Meta
import Dungeon/Config as Config
import Dungeon/HeroDef as HeroDef
import Dungeon/HeroProfile as HeroProfile
import Dungeon/MonsterDef as MonsterDef
import Dungeon/SwordDef as SwordDef
import Dungeon/PotionDef as PotionDef
import Dungeon/DeckEntry as DeckEntry
import Dungeon/PackDef as PackDef
import Dungeon/PackInventoryEntry as PackInventoryEntry
import Dungeon/config as config
import Dungeon/Deck/counts_pick/deck_count_for_card as deck_count_for_card
import Dungeon/Boosters/inventory/pack_inventory_count as pack_inventory_count
import Dungeon/profile_helpers/default_profile_for_hero as default_profile_for_hero
import Dungeon/profile_helpers/profile_unlocked as profile_unlocked
import Dungeon/profile_helpers/profile_hero_level as profile_hero_level
def meta_to_string(meta_state: Meta) -> String:
  _meta_to_string_from_config(config(), meta_state)

def _meta_to_string_from_config(config_value: Config, meta_state: Meta) -> String:
  match config_value meta_state:
    case config{heroes, monsters, swords, potions, deck, booster_packs, starting_dungeon_level} meta{selected_hero_ref, selection_confirmed_value, gold, bonus_deck, pack_inventory, hero_profiles}:
      String/join(
        [
          "v5",
          U32.show(selected_hero_ref),
          U32.show(selection_confirmed_value),
          U32.show(gold),
          String/join(_monster_bonus_counts(monsters, bonus_deck, 0), ","),
          String/join(_sword_bonus_counts(swords, bonus_deck, 0), ","),
          String/join(_potion_bonus_counts(potions, bonus_deck, 0), ","),
          String/join(_pack_inventory_counts(booster_packs, pack_inventory, 0), ","),
          String/join(_profile_strings(heroes, hero_profiles, 0), ";")
        ],
        "|"
      )

def _profile_strings(heroes: List(HeroDef), profiles: List(HeroProfile), hero_ref: U32) -> List(String):
  match heroes profiles:
    case [] _:
      []
    case hero_value<>hero_rest []:
      _profile_string(default_profile_for_hero(hero_ref))<>_profile_strings(hero_rest, [], hero_ref + 1)
    case hero_value<>hero_rest profile<>profile_rest:
      _profile_string(profile)<>_profile_strings(hero_rest, profile_rest, hero_ref + 1)

def _profile_string(profile: HeroProfile) -> String:
  String/join(
    [
      U32.show(profile_unlocked(profile)),
      U32.show(profile_hero_level(profile))
    ],
    "~"
  )

def _monster_bonus_counts(monsters: List(MonsterDef), bonus_deck: List(DeckEntry), idx: U32) -> List(String):
  match monsters:
    case []:
      []
    case monster_def{name, sprite, gold_drop, hp_levels}<>rest:
      U32.show(deck_count_for_card(bonus_deck, monster_card{idx}))<>_monster_bonus_counts(rest, bonus_deck, idx + 1)

def _sword_bonus_counts(swords: List(SwordDef), bonus_deck: List(DeckEntry), idx: U32) -> List(String):
  match swords:
    case []:
      []
    case sword_def{name, sprite, dmg}<>rest:
      U32.show(deck_count_for_card(bonus_deck, sword_card{idx}))<>_sword_bonus_counts(rest, bonus_deck, idx + 1)

def _potion_bonus_counts(potions: List(PotionDef), bonus_deck: List(DeckEntry), idx: U32) -> List(String):
  match potions:
    case []:
      []
    case potion_def{name, sprite, heal}<>rest:
      U32.show(deck_count_for_card(bonus_deck, potion_card{idx}))<>_potion_bonus_counts(rest, bonus_deck, idx + 1)

def _pack_inventory_counts(packs: List(PackDef), pack_inventory: List(PackInventoryEntry), idx: U32) -> List(String):
  match packs:
    case []:
      []
    case pack_def{name, price, reveal_count, allow_duplicates, pool}<>rest:
      U32.show(pack_inventory_count(pack_inventory, idx))<>_pack_inventory_counts(rest, pack_inventory, idx + 1)
