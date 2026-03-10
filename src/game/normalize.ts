import type {
  BalanceData,
  CoreConfig,
  CoreDeckEntry,
  GoldItemData,
  ItemData,
  MonsterData,
  NormalizedBalance,
  PotionItemData,
  SwordItemData,
} from "./types";

function expectItemKind<T extends ItemData["kind"]>(
  items: ItemData[],
  kind: T,
): Extract<ItemData, { kind: T }>[] {
  return items.filter(item => item.kind === kind) as Extract<ItemData, { kind: T }>[];
}

export function normalizeBalanceData(balance: BalanceData): NormalizedBalance {
  var heroIndex = balance.heroes.findIndex(hero => hero.id === balance.economy.defaultHeroId);
  var hero = balance.heroes[heroIndex];
  var monsters = balance.monsters.slice();
  var swords = expectItemKind(balance.items, "sword") as SwordItemData[];
  var potions = expectItemKind(balance.items, "potion") as PotionItemData[];
  var goldItem = expectItemKind(balance.items, "gold")[0] as GoldItemData;
  var monsterRef = new Map<string, number>();
  var swordRef = new Map<string, number>();
  var potionRef = new Map<string, number>();

  monsters.forEach((monster, index) => monsterRef.set(monster.id, index));
  swords.forEach((item, index) => swordRef.set(item.id, index));
  potions.forEach((item, index) => potionRef.set(item.id, index));

  var deck: CoreDeckEntry[] = balance.deck.entries.map(entry => {
    if (entry.cardId === hero.id) {
      return { kind: 3, ref: 0, count: entry.count };
    }
    var monster = monsterRef.get(entry.cardId);
    if (monster !== undefined) {
      return { kind: 0, ref: monster, count: entry.count };
    }
    var sword = swordRef.get(entry.cardId);
    if (sword !== undefined) {
      return { kind: 1, ref: sword, count: entry.count };
    }
    var potion = potionRef.get(entry.cardId);
    if (potion !== undefined) {
      return { kind: 2, ref: potion, count: entry.count };
    }
    throw new Error("normalize: unknown deck card " + entry.cardId);
  });

  var core: CoreConfig = {
    hero_base_max_hp: hero.baseMaxHp,
    upgrades: hero.upgrades.map(upgrade => ({
      cost: upgrade.cost,
      max_hp: upgrade.maxHp,
    })),
    monsters: monsters.map((monster: MonsterData) => ({
      gold_drop: monster.goldDrop,
      hp_levels: monster.hpByLevel.slice(),
    })),
    swords: swords.map((item: SwordItemData) => ({ dmg: item.dmg })),
    potions: potions.map((item: PotionItemData) => ({ heal: item.heal })),
    deck,
    base_deck_size: balance.deck.baseSize,
    starting_dungeon_level: balance.economy.startingDungeonLevel,
  };

  return {
    balance,
    core,
    hero,
    heroIndex,
    monsterOrder: monsters,
    swordOrder: swords,
    potionOrder: potions,
    goldItem,
    startingGold: balance.economy.startingGold,
  };
}

export function nextUpgradeCost(balance: NormalizedBalance, heroLevel: number): number | null {
  var step = balance.hero.upgrades[heroLevel];
  return step === undefined ? null : step.cost;
}
