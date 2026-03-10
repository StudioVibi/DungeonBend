export type HeroUpgrade = {
  level: number;
  cost: number;
  maxHp: number;
};

export type HeroData = {
  id: string;
  name: string;
  sprite: string;
  baseMaxHp: number;
  upgrades: HeroUpgrade[];
};

export type MonsterData = {
  id: string;
  name: string;
  sprite: string;
  hpByLevel: number[];
  goldDrop: number;
};

export type SwordItemData = {
  id: string;
  name: string;
  kind: "sword";
  sprite: string;
  dmg: number;
};

export type PotionItemData = {
  id: string;
  name: string;
  kind: "potion";
  sprite: string;
  heal: number;
};

export type GoldItemData = {
  id: string;
  name: string;
  kind: "gold";
  sprite: string;
};

export type ItemData = SwordItemData | PotionItemData | GoldItemData;

export type DeckEntryData = {
  cardId: string;
  count: number;
};

export type DeckData = {
  baseSize: number;
  entries: DeckEntryData[];
};

export type EconomyData = {
  defaultHeroId: string;
  startingGold: number;
  startingDungeonLevel: number;
};

export type BalanceData = {
  heroes: HeroData[];
  monsters: MonsterData[];
  items: ItemData[];
  deck: DeckData;
  economy: EconomyData;
};

export type CoreUpgrade = {
  cost: number;
  max_hp: number;
};

export type CoreMonster = {
  gold_drop: number;
  hp_levels: number[];
};

export type CoreSword = {
  dmg: number;
};

export type CorePotion = {
  heal: number;
};

export type CoreDeckEntry = {
  kind: number;
  ref: number;
  count: number;
};

export type CoreConfig = {
  hero_base_max_hp: number;
  upgrades: CoreUpgrade[];
  monsters: CoreMonster[];
  swords: CoreSword[];
  potions: CorePotion[];
  deck: CoreDeckEntry[];
  base_deck_size: number;
  starting_dungeon_level: number;
};

export type NormalizedBalance = {
  balance: BalanceData;
  core: CoreConfig;
  hero: HeroData;
  heroIndex: number;
  monsterOrder: MonsterData[];
  swordOrder: SwordItemData[];
  potionOrder: PotionItemData[];
  goldItem: GoldItemData;
  startingGold: number;
};

export type MetaState = {
  heroId: string;
  heroLevel: number;
  gold: number;
};

export type Direction = "up" | "down" | "left" | "right";

export type CoreWeaponState =
  | { tag: "none" }
  | { tag: "weapon"; ref: number; dmg: number };

export type CoreBoardTile =
  | { tag: "none" }
  | { tag: "monster"; ref: number; hp: number }
  | { tag: "sword"; ref: number; dmg: number }
  | { tag: "potion"; ref: number; heal: number }
  | { tag: "gold"; amount: number };

export type RunState = {
  dungeonLevel: number;
  heroHp: number;
  heroMaxHp: number;
  heroIndex: number;
  weapon: CoreWeaponState;
  board: CoreBoardTile[];
  deckBlueprint: CoreDeckEntry[];
  drawCounts: CoreDeckEntry[];
  remaining: number;
  capacity: number;
  seed: number;
  status: "running" | "game_over";
};

export type SwipeResult = {
  meta: MetaState;
  run: RunState;
};
