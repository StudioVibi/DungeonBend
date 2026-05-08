type Upgrade {
  upgrade{cost: U32, max_hp: U32}
}

type HeroDef {
  hero_def{
    id: String,
    name: String,
    sprite: String,
    base_max_hp: U32,
    unlock_cost: U32,
    starts_unlocked: U32,
    upgrades: List(Upgrade)
  }
}

type PresentationAlign {
  presentation_left{}
  presentation_center{}
  presentation_right{}
}

type HeroPresentation {
  hero_presentation{
    hero_id: String,
    name_align: PresentationAlign,
    lore: String,
    ultimate_title: String,
    ultimate_icon: String,
    ultimate_description: String
  }
}

type MonsterDef {
  monster_def{name: String, sprite: String, gold_drop: U32, hp_levels: List(U32)}
}

type SwordDef {
  sword_def{name: String, sprite: String, dmg: U32}
}

type PotionDef {
  potion_def{name: String, sprite: String, heal: U32}
}

type DeckEntry {
  monster_entry{ref: U32, count: U32}
  sword_entry{ref: U32, count: U32}
  potion_entry{ref: U32, count: U32}
  hero_entry{count: U32}
}

type CardRef {
  monster_card{ref: U32}
  sword_card{ref: U32}
  potion_card{ref: U32}
  hero_card{}
}

type PackPoolEntry {
  pack_pool_entry{card: CardRef, weight: U32}
}

type PackDef {
  pack_def{
    name: String,
    price: U32,
    reveal_count: U32,
    allow_duplicates: U32,
    pool: List(PackPoolEntry)
  }
}

type PackReward {
  no_pack_reward{}
  pack_reward{cards: List(CardRef)}
}

type PackOpenResult {
  pack_open_result{reward: PackReward, seed: U32}
}

type PackInventoryEntry {
  pack_inventory_entry{ref: U32, count: U32}
}

type Direction {
  up{}
  down{}
  left{}
  right{}
}

type Weapon {
  no_weapon{}
  weapon{ref: U32, dmg: U32}
}

type Tile {
  none{}
  monster{ref: U32, hp: U32}
  sword{ref: U32, dmg: U32}
  potion{ref: U32, heal: U32}
  gold{amount: U32}
}

type Board {
  board{cells: Nat/V2/Map(Tile)}
}

type BoardDraw {
  board_draw{
    board: Board,
    counts: List(DeckEntry),
    remaining: U32,
    seed: U32,
    level: U32
  }
}

type DrawResult {
  draw_result{
    tile: Tile,
    counts: List(DeckEntry),
    remaining: U32,
    seed: U32,
    level: U32
  }
}

type CombatOutcome {
  combat_continue{}
  combat_game_over{}
}

type CombatResult {
  combat_result{
    hero_hp: U32,
    weapon: Weapon,
    board: Board,
    outcome: CombatOutcome
  }
}

type HeroProfile {
  hero_profile{
    unlocked: U32,
    hero_level: U32
  }
}

type DeckRecord {
  deck_record{
    id: U32,
    name: String,
    entries: List(DeckEntry)
  }
}

type DeckQuotas {
  deck_quotas{
    monsters: U32,
    swords: U32,
    potions: U32,
    hero: U32,
    total: U32
  }
}

type DeckCategory {
  cat_monsters{}
  cat_swords{}
  cat_potions{}
  cat_hero{}
}

type DeckDraft {
  deck_draft{
    deck_id: U32,
    name: String,
    entries: List(DeckEntry),
    dirty: U32
  }
}

type DeckListMode {
  deck_list_view{}
  deck_list_edit{selected_ids: List(U32)}
  deck_list_confirm_delete{selected_ids: List(U32)}
}

type DeckPickerMode {
  picker_none{}
  picker_open{category: DeckCategory}
}

type DeckDetailMode {
  detail_view{}
  detail_confirm_discard{}
  detail_pending_delete{card: CardRef, occurrence: U32}
}

type Meta {
  meta{
    selected_hero: U32,
    selection_confirmed: U32,
    gold: U32,
    bonus_deck: List(DeckEntry),
    pack_inventory: List(PackInventoryEntry),
    hero_profiles: List(HeroProfile),
    decks: List(DeckRecord),
    active_deck_id: U32,
    next_deck_id: U32
  }
}

type Config {
  config{
    heroes: List(HeroDef),
    monsters: List(MonsterDef),
    swords: List(SwordDef),
    potions: List(PotionDef),
    deck: List(DeckEntry),
    booster_packs: List(PackDef),
    starting_dungeon_level: U32
  }
}

type Run {
  run{
    dungeon_level: U32,
    hero_hp: U32,
    hero_max_hp: U32,
    hero_index: U32,
    weapon: Weapon,
    board: Board,
    deck_blueprint: List(DeckEntry),
    draw_counts: List(DeckEntry),
    remaining: U32,
    capacity: U32,
    seed: U32,
    ult_charge: U32,
    hero_ref: U32
  }
}

type RunAdvance {
  keep_running{run: Run}
  end_run{run: Run}
}

type SwipeResult {
  swipe_result{meta: Meta, next: RunAdvance}
}

type BoosterReturn {
  booster_return_setup{}
  booster_return_character_select{preview_hero: U32}
}

type Scene {
  setup{}
  character_select{preview_hero: U32}
  boosters{reward: PackReward, reveal_index: U32, return_to: BoosterReturn}
  ultimate_preview{fx: UltimatePreviewFx}
  ultimate_cinematic{run: Run, ticks_remaining: U32}
  running{run: Run}
  paused{run: Run}
  resume_prompt{run: Run}
  game_over{run: Run}
  deck_list{mode: DeckListMode}
  deck_detail{deck_id: U32, draft: DeckDraft, picker: DeckPickerMode, detail_mode: DeckDetailMode}
}

type SavedScene {
  saved_setup{}
  saved_character_select{preview_hero: U32}
  saved_boosters{reward: PackReward, reveal_index: U32}
  saved_running{run: Run}
}

type GameState {
  game_state{meta: Meta, scene: Scene, next_seed: U32}
}

type HpFx {
  hp_fx_none{}
  hp_fx_heal_a{}
  hp_fx_heal_b{}
  hp_fx_hurt_a{}
  hp_fx_hurt_b{}
}

type DmgFx {
  dmg_fx_none{}
  dmg_fx_up_a{}
  dmg_fx_up_b{}
  dmg_fx_down_a{}
  dmg_fx_down_b{}
}

type ImpactFx {
  impact_hit_a{}
  impact_hit_b{}
  impact_kill_a{}
  impact_kill_b{}
}

type Impact {
  no_impact{}
  impact{pos: Nat/V2, fx: ImpactFx}
}

type DamageOverlay {
  no_damage_overlay{}
  damage_overlay{pos: Nat/V2, trigger: ImpactFx, base_tile: Tile, state: Midum/Image/State}
}

type DeckCounterFx {
  deck_counter_idle{}
  deck_counter_playing{state: Midum/Image/State}
}

type UltimatePreviewFx {
  ultimate_preview_idle{}
  ultimate_preview_play_a{}
  ultimate_preview_play_b{}
}

type UltimateCutinSpec {
  ultimate_cutin_spec{
    banner_src: String,
    character_src: String,
    desktop_y_offset: String,
    mobile_y_offset: String,
    character_width: String,
    band_height: String,
    duration_ticks: U32,
    sound_placeholder: String
  }
}

type UiState {
  ui_state{
    hp_fx: HpFx,
    dmg_fx: DmgFx,
    impact: Impact,
    damage_overlay: DamageOverlay,
    deck_counter_fx: DeckCounterFx,
    menu_background_state: Midum/Image/State
  }
}

type DungeonState {
  dungeon{game: GameState, ui: UiState}
}

type DungeonEvent {
  start{}
  upgrade{}
  open_character_select{}
  close_character_select{}
  open_ultimate_preview{}
  close_ultimate_preview{}
  preview_character{ref: U32}
  select_character{}
  open_boosters{}
  close_boosters{}
  buy_pack{ref: U32}
  open_pack{ref: U32}
  prev_reward{}
  next_reward{}
  done_reward{}
  play_ultimate_preview{}
  ultimate{}
  move{dir: Direction}
  damage_tick{}
  ok{}
  pause_dungeon{}
  resume_dungeon{}
  abandon_dungeon{}
  ignore{}
  loaded{meta: Meta, saved_scene: SavedScene, next_seed: U32}
  no_save{}
  open_deck_list{}
  close_deck_list{}
  enter_deck_edit_mode{}
  exit_deck_edit_mode{}
  toggle_deck_select{deck_id: U32}
  request_delete_decks{}
  confirm_delete_decks{}
  cancel_delete_decks{}
  create_new_deck{}
  open_deck_detail{deck_id: U32}
  close_deck_detail{}
  request_close_deck_detail{}
  discard_deck_changes{}
  cancel_discard_deck_changes{}
  add_card_to_deck{card: CardRef}
  remove_card_from_deck{card: CardRef, occurrence: U32}
  save_deck_changes{}
  set_active_deck{deck_id: U32}
  open_category_picker{category: DeckCategory}
  close_category_picker{}
}

type _PickResult {
  no_pick{counts: List(DeckEntry)}
  picked_entry{entry: DeckEntry, counts: List(DeckEntry)}
}

type _PackPickResult {
  no_pack_pick{pool: List(PackPoolEntry)}
  picked_pack_entry{card: CardRef, pool: List(PackPoolEntry)}
}
