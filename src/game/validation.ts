import type {
  BalanceData,
  DeckData,
  DeckEntryData,
  EconomyData,
  GoldItemData,
  HeroData,
  HeroUpgrade,
  ItemData,
  MonsterData,
  PotionItemData,
  SwordItemData,
} from "./types";

function fail(path: string, message: string): never {
  throw new Error(path + ": " + message);
}

function asRecord(value: unknown, path: string): Record<string, unknown> {
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    fail(path, "expected object");
  }
  return value as Record<string, unknown>;
}

function asString(value: unknown, path: string): string {
  if (typeof value !== "string" || value.trim() === "") {
    fail(path, "expected non-empty string");
  }
  return value;
}

function asInteger(value: unknown, path: string): number {
  if (typeof value !== "number" || !Number.isInteger(value) || value < 0) {
    fail(path, "expected non-negative integer");
  }
  return value;
}

function asArray(value: unknown, path: string): unknown[] {
  if (!Array.isArray(value)) {
    fail(path, "expected array");
  }
  return value;
}

function parseUpgrade(value: unknown, index: number): HeroUpgrade {
  var row = asRecord(value, "heroes[" + index + "].upgrades[]");
  return {
    level: asInteger(row.level, "heroes[" + index + "].upgrades.level"),
    cost: asInteger(row.cost, "heroes[" + index + "].upgrades.cost"),
    maxHp: asInteger(row.maxHp, "heroes[" + index + "].upgrades.maxHp"),
  };
}

function parseHero(value: unknown, index: number): HeroData {
  var row = asRecord(value, "heroes[" + index + "]");
  return {
    id: asString(row.id, "heroes[" + index + "].id"),
    name: asString(row.name, "heroes[" + index + "].name"),
    sprite: asString(row.sprite, "heroes[" + index + "].sprite"),
    baseMaxHp: asInteger(row.baseMaxHp, "heroes[" + index + "].baseMaxHp"),
    upgrades: asArray(row.upgrades, "heroes[" + index + "].upgrades").map(parseUpgrade),
  };
}

function parseMonster(value: unknown, index: number): MonsterData {
  var row = asRecord(value, "monsters[" + index + "]");
  return {
    id: asString(row.id, "monsters[" + index + "].id"),
    name: asString(row.name, "monsters[" + index + "].name"),
    sprite: asString(row.sprite, "monsters[" + index + "].sprite"),
    hpByLevel: asArray(row.hpByLevel, "monsters[" + index + "].hpByLevel")
      .map((hp, hpIndex) => asInteger(hp, "monsters[" + index + "].hpByLevel[" + hpIndex + "]")),
    goldDrop: asInteger(row.goldDrop, "monsters[" + index + "].goldDrop"),
  };
}

function parseSword(row: Record<string, unknown>, index: number): SwordItemData {
  return {
    id: asString(row.id, "items[" + index + "].id"),
    name: asString(row.name, "items[" + index + "].name"),
    kind: "sword",
    sprite: asString(row.sprite, "items[" + index + "].sprite"),
    dmg: asInteger(row.dmg, "items[" + index + "].dmg"),
  };
}

function parsePotion(row: Record<string, unknown>, index: number): PotionItemData {
  return {
    id: asString(row.id, "items[" + index + "].id"),
    name: asString(row.name, "items[" + index + "].name"),
    kind: "potion",
    sprite: asString(row.sprite, "items[" + index + "].sprite"),
    heal: asInteger(row.heal, "items[" + index + "].heal"),
  };
}

function parseGold(row: Record<string, unknown>, index: number): GoldItemData {
  return {
    id: asString(row.id, "items[" + index + "].id"),
    name: asString(row.name, "items[" + index + "].name"),
    kind: "gold",
    sprite: asString(row.sprite, "items[" + index + "].sprite"),
  };
}

function parseItem(value: unknown, index: number): ItemData {
  var row = asRecord(value, "items[" + index + "]");
  var kind = asString(row.kind, "items[" + index + "].kind");
  if (kind === "sword") {
    return parseSword(row, index);
  }
  if (kind === "potion") {
    return parsePotion(row, index);
  }
  if (kind === "gold") {
    return parseGold(row, index);
  }
  fail("items[" + index + "].kind", "expected sword, potion, or gold");
}

function parseDeckEntry(value: unknown, index: number): DeckEntryData {
  var row = asRecord(value, "deck.entries[" + index + "]");
  return {
    cardId: asString(row.cardId, "deck.entries[" + index + "].cardId"),
    count: asInteger(row.count, "deck.entries[" + index + "].count"),
  };
}

function parseDeck(value: unknown): DeckData {
  var row = asRecord(value, "deck");
  return {
    baseSize: asInteger(row.baseSize, "deck.baseSize"),
    entries: asArray(row.entries, "deck.entries").map(parseDeckEntry),
  };
}

function parseEconomy(value: unknown): EconomyData {
  var row = asRecord(value, "economy");
  return {
    defaultHeroId: asString(row.defaultHeroId, "economy.defaultHeroId"),
    startingGold: asInteger(row.startingGold, "economy.startingGold"),
    startingDungeonLevel: asInteger(row.startingDungeonLevel, "economy.startingDungeonLevel"),
  };
}

function assertUniqueId(ids: string[], scope: string): void {
  var seen = new Set<string>();
  for (var id of ids) {
    if (seen.has(id)) {
      fail(scope, "duplicate id: " + id);
    }
    seen.add(id);
  }
}

export function parseBalanceData(value: unknown): BalanceData {
  var row = asRecord(value, "balance");
  var balance: BalanceData = {
    heroes: asArray(row.heroes, "heroes").map(parseHero),
    monsters: asArray(row.monsters, "monsters").map(parseMonster),
    items: asArray(row.items, "items").map(parseItem),
    deck: parseDeck(row.deck),
    economy: parseEconomy(row.economy),
  };

  assertUniqueId(balance.heroes.map(hero => hero.id), "heroes");
  assertUniqueId(balance.monsters.map(monster => monster.id), "monsters");
  assertUniqueId(balance.items.map(item => item.id), "items");
  assertUniqueId(
    balance.heroes.map(hero => hero.id)
      .concat(balance.monsters.map(monster => monster.id))
      .concat(balance.items.map(item => item.id)),
    "balance",
  );

  if (balance.heroes.length === 0) {
    fail("heroes", "expected at least one hero");
  }
  if (balance.monsters.length === 0) {
    fail("monsters", "expected at least one monster");
  }

  var total = 0;
  for (var entry of balance.deck.entries) {
    total += entry.count;
  }
  if (total !== balance.deck.baseSize) {
    fail("deck.entries", "count total must equal deck.baseSize");
  }
  if (balance.deck.baseSize !== 20) {
    fail("deck.baseSize", "expected 20 for v1");
  }

  var heroRef = balance.heroes.find(hero => hero.id === balance.economy.defaultHeroId);
  if (heroRef === undefined) {
    fail("economy.defaultHeroId", "unknown hero id");
  }

  var knownIds = new Set<string>();
  for (var hero of balance.heroes) {
    knownIds.add(hero.id);
    if (hero.baseMaxHp === 0) {
      fail("heroes[" + hero.id + "]", "baseMaxHp must be greater than zero");
    }
    var expectedLevel = 1;
    var prevMaxHp = hero.baseMaxHp;
    for (var upgrade of hero.upgrades) {
      if (upgrade.level !== expectedLevel) {
        fail("heroes[" + hero.id + "].upgrades", "levels must start at 1 and increase by 1");
      }
      if (upgrade.maxHp <= prevMaxHp) {
        fail("heroes[" + hero.id + "].upgrades", "maxHp must increase each step");
      }
      expectedLevel += 1;
      prevMaxHp = upgrade.maxHp;
    }
  }

  for (var monster of balance.monsters) {
    knownIds.add(monster.id);
    if (monster.hpByLevel.length === 0) {
      fail("monsters[" + monster.id + "].hpByLevel", "expected at least one level");
    }
  }

  var goldItemCount = 0;
  for (var item of balance.items) {
    knownIds.add(item.id);
    if (item.kind === "gold") {
      goldItemCount += 1;
    }
  }

  if (goldItemCount !== 1) {
    fail("items", "expected exactly one gold item");
  }

  var heroDeckCount = 0;
  for (var entry of balance.deck.entries) {
    if (!knownIds.has(entry.cardId)) {
      fail("deck.entries", "unknown cardId: " + entry.cardId);
    }
    if (entry.cardId === balance.economy.defaultHeroId) {
      heroDeckCount += entry.count;
    }
  }
  if (heroDeckCount !== 1) {
    fail("deck.entries", "expected exactly one hero card in the base deck");
  }

  return balance;
}
