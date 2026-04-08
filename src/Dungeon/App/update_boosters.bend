import /Dungeon/DeckEntry as DeckEntry
import /Dungeon/PackReward as PackReward
import /Dungeon/PackOpenResult as PackOpenResult
import /Dungeon/PackInventoryEntry as PackInventoryEntry
import /Dungeon/Meta as Meta
import /Dungeon/Config as Config
import /Dungeon/PackDef as PackDef
import /Dungeon/UiState as UiState
import /Dungeon/DungeonEvent as DungeonEvent
import /Dungeon/DungeonState as DungeonState
import /Dungeon/config as config
import /Dungeon/default_ui as default_ui
import /Dungeon/App/state_helpers/_state as _state
import /Dungeon/Boosters/inventory/pack_inventory_count as pack_inventory_count
import /Dungeon/Boosters/inventory/add_pack as add_pack
import /Dungeon/Boosters/inventory/consume_pack as consume_pack
import /Dungeon/Boosters/packs/pack_at as pack_at
import /Dungeon/Boosters/reveal/open_pack as open_pack
import /Dungeon/Boosters/collection/bonus_deck_after_reward as bonus_deck_after_reward
import /Dungeon/Boosters/reward_nav/next_reward_index as next_reward_index
import /Dungeon/Boosters/reward_nav/prev_reward_index as prev_reward_index

def update_boosters(evt: DungeonEvent, meta_state: Meta, reward: PackReward, reveal_index: U32, next_seed_value: U32, ui_value: UiState) -> DungeonState:
  match evt:
    case close_boosters{}:
      _state(meta_state, setup{}, next_seed_value, default_ui())
    case buy_pack{ref}:
      _buy_pack_state(config(), meta_state, reward, reveal_index, ref, next_seed_value)
    case open_pack{ref}:
      _open_pack_state(config(), meta_state, reward, ref, next_seed_value)
    case prev_reward{}:
      _state(meta_state, boosters{reward, prev_reward_index(reveal_index)}, next_seed_value, ui_value)
    case next_reward{}:
      _state(meta_state, boosters{reward, next_reward_index(reward, reveal_index)}, next_seed_value, ui_value)
    case _:
      _state(meta_state, boosters{reward, reveal_index}, next_seed_value, ui_value)

def _buy_pack_state(config_value: Config, meta_state: Meta, reward: PackReward, reveal_index: U32, ref: U32, next_seed_value: U32) -> DungeonState:
  match config_value:
    case config{hero, upgrades, monsters, swords, potions, deck, booster_packs, starting_dungeon_level}:
      _state(_buy_pack_meta(meta_state, ref, pack_at(booster_packs, ref)), boosters{reward, reveal_index}, next_seed_value, default_ui())

def _buy_pack_meta(meta_state: Meta, ref: U32, pack: PackDef) -> Meta:
  match meta_state pack:
    case meta{hero_level, gold, bonus_deck, pack_inventory} pack_def{name, price, reveal_count, allow_duplicates, pool}:
      _buy_pack_affordable(gold < price, hero_level, gold, bonus_deck, pack_inventory, ref, price)

def _buy_pack_affordable(gold_lt_price: U32, hero_level: U32, gold: U32, bonus_deck: List(DeckEntry), pack_inventory: List(PackInventoryEntry), ref: U32, price: U32) -> Meta:
  match gold_lt_price:
    case 0:
      meta{hero_level, gold - price, bonus_deck, add_pack(pack_inventory, ref)}
    case _:
      meta{hero_level, gold, bonus_deck, pack_inventory}

def _open_pack_state(config_value: Config, meta_state: Meta, current_reward: PackReward, ref: U32, next_seed_value: U32) -> DungeonState:
  match config_value meta_state:
    case config{hero, upgrades, monsters, swords, potions, deck, booster_packs, starting_dungeon_level} meta{hero_level, gold, bonus_deck, pack_inventory}:
      _open_pack_inventory(
        pack_inventory_count(pack_inventory, ref),
        hero_level,
        gold,
        bonus_deck,
        pack_inventory,
        ref,
        pack_at(booster_packs, ref),
        current_reward,
        next_seed_value
      )

def _open_pack_inventory(inventory_count: U32, hero_level: U32, gold: U32, bonus_deck: List(DeckEntry), pack_inventory: List(PackInventoryEntry), ref: U32, pack: PackDef, current_reward: PackReward, next_seed_value: U32) -> DungeonState:
  match inventory_count:
    case 0:
      _state(meta{hero_level, gold, bonus_deck, pack_inventory}, boosters{current_reward, 0}, next_seed_value, default_ui())
    case _:
      _open_pack_result(hero_level, gold, bonus_deck, pack_inventory, ref, open_pack(pack, next_seed_value))

def _open_pack_result(hero_level: U32, gold: U32, bonus_deck: List(DeckEntry), pack_inventory: List(PackInventoryEntry), ref: U32, result: PackOpenResult) -> DungeonState:
  match result:
    case pack_open_result{reward, next_seed}:
      next_bonus = bonus_deck_after_reward(bonus_deck, reward);
      next_inventory = consume_pack(pack_inventory, ref);
      _state(meta{hero_level, gold, next_bonus, next_inventory}, boosters{reward, 0}, next_seed, default_ui())
