import * as path from "node:path";
import * as process from "node:process";
import * as Bend from "../../Bend2/bend-ts/src/Bend.ts";

type RawHero = {
  id: string;
  name: string;
  sprite: string;
  base_max_hp: number;
};

type RawMonster = {
  id: string;
  name: string;
  sprite: string;
  gold_drop: number;
  hp_levels: number[];
};

type RawSword = {
  id: string;
  name: string;
  sprite: string;
  dmg: number;
};

type RawPotion = {
  id: string;
  name: string;
  sprite: string;
  heal: number;
};

type RawUpgrade = {
  cost: number;
  max_hp: number;
};

type RawDeckEntry = {
  card_id: string;
  count: number;
};

type RawPack = {
  id: string;
  name: string;
  price: number;
  reveal_count: number;
  allow_duplicates: boolean;
};

type RawPackPoolEntry = {
  pack_id: string;
  card_id: string;
  weight: number;
};

type RawDungeonConfig = {
  cards: {
    hero: RawHero;
    monsters: RawMonster[];
    swords: RawSword[];
    potions: RawPotion[];
  };
  hero_upgrades: RawUpgrade[];
  base_deck: RawDeckEntry[];
  booster_packs: RawPack[];
  booster_pack_pool: RawPackPoolEntry[];
  economy: {
    starting_dungeon_level: number;
  };
};

type CardKind = "hero" | "monster" | "sword" | "potion";

type CardIndex = {
  kind: CardKind;
  index: number;
};

function fail(message: string): never {
  throw new Error(`Dungeon config error: ${message}`);
}

function validatePositiveInt(value: number, label: string): number {
  if (!Number.isInteger(value) || value <= 0) {
    fail(`${label} must be a positive integer`);
  }
  return value;
}

function validateString(value: string, label: string): string {
  if (typeof value !== "string" || value.trim() === "") {
    fail(`${label} must be a non-empty string`);
  }
  return value;
}

function bendString(value: string): string {
  return JSON.stringify(value);
}

function indent(size: number): string {
  return " ".repeat(size);
}

function bendList(items: string[], size: number): string {
  if (items.length === 0) {
    return "[]";
  }
  const outer = indent(size);
  const inner = indent(size + 2);
  return `[\n${items.map((item) => `${inner}${item}`).join(",\n")}\n${outer}]`;
}

function buildCardIndexes(raw: RawDungeonConfig): Map<string, CardIndex> {
  const indexes = new Map<string, CardIndex>();
  const push = (id: string, card: CardIndex) => {
    if (indexes.has(id)) {
      fail(`duplicate card id "${id}"`);
    }
    indexes.set(id, card);
  };

  push(validateString(raw.cards.hero.id, "cards.hero.id"), { kind: "hero", index: 0 });
  raw.cards.monsters.forEach((monster, index) => {
    push(validateString(monster.id, `cards.monsters[${index}].id`), { kind: "monster", index });
  });
  raw.cards.swords.forEach((sword, index) => {
    push(validateString(sword.id, `cards.swords[${index}].id`), { kind: "sword", index });
  });
  raw.cards.potions.forEach((potion, index) => {
    push(validateString(potion.id, `cards.potions[${index}].id`), { kind: "potion", index });
  });

  return indexes;
}

function renderCardRef(card: CardIndex): string {
  switch (card.kind) {
    case "hero":
      return "hero_card{}";
    case "monster":
      return `monster_card{${card.index}}`;
    case "sword":
      return `sword_card{${card.index}}`;
    case "potion":
      return `potion_card{${card.index}}`;
  }
}

function renderDeckEntry(card: CardIndex, count: number): string {
  switch (card.kind) {
    case "hero":
      return `hero_entry{${count}}`;
    case "monster":
      return `monster_entry{${card.index}, ${count}}`;
    case "sword":
      return `sword_entry{${card.index}, ${count}}`;
    case "potion":
      return `potion_entry{${card.index}, ${count}}`;
  }
}

function renderConfigModule(raw: RawDungeonConfig): string {
  const cardIndexes = buildCardIndexes(raw);

  const hero = raw.cards.hero;
  validateString(hero.name, "cards.hero.name");
  validateString(hero.sprite, "cards.hero.sprite");
  validatePositiveInt(hero.base_max_hp, "cards.hero.base_max_hp");

  const monsterDefs = raw.cards.monsters.map((monster, index) => {
    validateString(monster.name, `cards.monsters[${index}].name`);
    validateString(monster.sprite, `cards.monsters[${index}].sprite`);
    validatePositiveInt(monster.gold_drop, `cards.monsters[${index}].gold_drop`);
    if (!Array.isArray(monster.hp_levels) || monster.hp_levels.length === 0) {
      fail(`cards.monsters[${index}].hp_levels must have at least one entry`);
    }
    const hpLevels = monster.hp_levels.map((value, levelIndex) =>
      String(validatePositiveInt(value, `cards.monsters[${index}].hp_levels[${levelIndex}]`))
    );
    return `monster_def{${bendString(monster.name)}, ${bendString(monster.sprite)}, ${monster.gold_drop}, ${bendList(hpLevels, 6)}}`;
  });

  const swordDefs = raw.cards.swords.map((sword, index) => {
    validateString(sword.name, `cards.swords[${index}].name`);
    validateString(sword.sprite, `cards.swords[${index}].sprite`);
    validatePositiveInt(sword.dmg, `cards.swords[${index}].dmg`);
    return `sword_def{${bendString(sword.name)}, ${bendString(sword.sprite)}, ${sword.dmg}}`;
  });

  const potionDefs = raw.cards.potions.map((potion, index) => {
    validateString(potion.name, `cards.potions[${index}].name`);
    validateString(potion.sprite, `cards.potions[${index}].sprite`);
    validatePositiveInt(potion.heal, `cards.potions[${index}].heal`);
    return `potion_def{${bendString(potion.name)}, ${bendString(potion.sprite)}, ${potion.heal}}`;
  });

  const upgrades = raw.hero_upgrades.map((upgrade, index) => {
    validatePositiveInt(upgrade.cost, `hero_upgrades[${index}].cost`);
    validatePositiveInt(upgrade.max_hp, `hero_upgrades[${index}].max_hp`);
    return `upgrade{${upgrade.cost}, ${upgrade.max_hp}}`;
  });

  if (upgrades.length === 0) {
    fail("hero_upgrades must contain at least one upgrade step");
  }

  const baseDeck = raw.base_deck.map((entry, index) => {
    const cardId = validateString(entry.card_id, `base_deck[${index}].card_id`);
    const card = cardIndexes.get(cardId);
    if (card === undefined) {
      fail(`base_deck[${index}] references unknown card_id "${cardId}"`);
    }
    return renderDeckEntry(card, validatePositiveInt(entry.count, `base_deck[${index}].count`));
  });

  if (baseDeck.length === 0) {
    fail("base_deck must contain at least one entry");
  }

  const packIndexById = new Map<string, number>();
  raw.booster_packs.forEach((pack, index) => {
    const packId = validateString(pack.id, `booster_packs[${index}].id`);
    if (packIndexById.has(packId)) {
      fail(`duplicate booster pack id "${packId}"`);
    }
    packIndexById.set(packId, index);
  });

  if (raw.booster_packs.length === 0) {
    fail("booster_packs must contain at least one pack");
  }

  const packPools = new Map<string, RawPackPoolEntry[]>();
  raw.booster_pack_pool.forEach((entry, index) => {
    const packId = validateString(entry.pack_id, `booster_pack_pool[${index}].pack_id`);
    const cardId = validateString(entry.card_id, `booster_pack_pool[${index}].card_id`);
    const card = cardIndexes.get(cardId);
    if (card === undefined) {
      fail(`booster_pack_pool[${index}] references unknown card_id "${cardId}"`);
    }
    if (card.kind === "hero") {
      fail(`booster_pack_pool[${index}] cannot reference the hero card`);
    }
    if (!packIndexById.has(packId)) {
      fail(`booster_pack_pool[${index}] references unknown pack_id "${packId}"`);
    }
    validatePositiveInt(entry.weight, `booster_pack_pool[${index}].weight`);
    const existing = packPools.get(packId) ?? [];
    if (existing.some((current) => current.card_id === cardId)) {
      fail(`pack "${packId}" contains duplicated pool entry for "${cardId}"`);
    }
    existing.push(entry);
    packPools.set(packId, existing);
  });

  const packs = raw.booster_packs.map((pack, index) => {
    validateString(pack.name, `booster_packs[${index}].name`);
    validatePositiveInt(pack.price, `booster_packs[${index}].price`);
    validatePositiveInt(pack.reveal_count, `booster_packs[${index}].reveal_count`);
    const poolEntries = packPools.get(pack.id) ?? [];
    if (poolEntries.length === 0) {
      fail(`booster pack "${pack.id}" is missing pool entries`);
    }
    if (!pack.allow_duplicates && poolEntries.length < pack.reveal_count) {
      fail(`booster pack "${pack.id}" needs at least ${pack.reveal_count} unique pool cards`);
    }
    const renderedPool = poolEntries.map((entry) => {
      const card = cardIndexes.get(entry.card_id);
      if (card === undefined) {
        fail(`booster pack "${pack.id}" references unknown card "${entry.card_id}"`);
      }
      return `pack_pool_entry{${renderCardRef(card)}, ${entry.weight}}`;
    });
    return `pack_def{${bendString(pack.name)}, ${pack.price}, ${pack.reveal_count}, ${pack.allow_duplicates ? 1 : 0}, ${bendList(renderedPool, 6)}}`;
  });

  validatePositiveInt(raw.economy.starting_dungeon_level, "economy.starting_dungeon_level");

  return [
    "import /Dungeon/Config as Config",
    "import /Dungeon/HeroDef as HeroDef",
    "import /Dungeon/Upgrade as Upgrade",
    "import /Dungeon/MonsterDef as MonsterDef",
    "import /Dungeon/SwordDef as SwordDef",
    "import /Dungeon/PotionDef as PotionDef",
    "import /Dungeon/DeckEntry as DeckEntry",
    "import /Dungeon/CardRef as CardRef",
    "import /Dungeon/PackPoolEntry as PackPoolEntry",
    "import /Dungeon/PackDef as PackDef",
    "",
    "def generated_config() -> Config:",
    "  config{",
    `    hero_def{${bendString(hero.name)}, ${bendString(hero.sprite)}, ${hero.base_max_hp}},`,
    `    ${bendList(upgrades, 4)},`,
    `    ${bendList(monsterDefs, 4)},`,
    `    ${bendList(swordDefs, 4)},`,
    `    ${bendList(potionDefs, 4)},`,
    `    ${bendList(baseDeck, 4)},`,
    `    ${bendList(packs, 4)},`,
    `    ${raw.economy.starting_dungeon_level}`,
    "  }",
    "",
  ].join("\n");
}

async function generateDungeonConfig(cwd: string): Promise<void> {
  const dataPath = path.resolve(cwd, "data/dungeon.config.json");
  const outPath = path.resolve(cwd, "src/Dungeon/generated_config.bend");
  const raw = (await Bun.file(dataPath).json()) as RawDungeonConfig;
  await Bun.write(outPath, renderConfigModule(raw));
}

function patchAppRuntime(html: string): string {
  const childPatchBuggy = [
    "    var nxt = __app_patch(kid, prev.kids[i], next.kids[i], dispatch, kidSvg);",
    "    if (nxt !== kid) {",
      "      dom.replaceChild(nxt, kid);",
    "    }",
  ].join("\n");

  const childPatchFixed = [
    "    var nxt = __app_patch(kid, prev.kids[i], next.kids[i], dispatch, kidSvg);",
    "    if (nxt !== kid && kid.parentNode === dom) {",
    "      dom.replaceChild(nxt, kid);",
    "    }",
  ].join("\n");

  const replaceBuggy = [
    "function __app_replace(dom, view, dispatch, svg) {",
    "  var nxt = __app_mount(view, dispatch, svg);",
    "  __app_dispose(dom);",
    "  dom.replaceWith(nxt);",
    "  return nxt;",
    "}",
  ].join("\n");

  const replaceFixed = [
    "function __app_replace(dom, view, dispatch, svg) {",
    "  var nxt = __app_mount(view, dispatch, svg);",
    "  __app_dispose(dom);",
    "  return nxt;",
    "}",
  ].join("\n");

  const stepBuggy = [
    "    dom  = __app_patch(dom, view, next, step, false);",
    "    view = next;",
  ].join("\n");

  const stepFixed = [
    "    dom  = __app_patch(dom, view, next, step, false);",
    "    if (dom.parentNode !== root) {",
    "      root.replaceChildren(dom);",
    "    }",
    "    view = next;",
  ].join("\n");

  let out = html;
  if (out.includes(childPatchBuggy)) {
    out = out.replace(childPatchBuggy, childPatchFixed);
  }
  if (out.includes(replaceBuggy)) {
    out = out.replace(replaceBuggy, replaceFixed);
  }
  if (out.includes(stepBuggy)) {
    out = out.replace(stepBuggy, stepFixed);
  }
  return out;
}

function usage(): never {
  console.error("usage: bun scripts/build.ts <input.bend> <output.html>");
  process.exit(1);
}

const input = process.argv[2];
const output = process.argv[3];

if (input === undefined || output === undefined) {
  usage();
}

const cwd = process.cwd();
const file = path.resolve(cwd, input);
const out = path.resolve(cwd, output);
const preludeDir = path.resolve(cwd, process.env.BEND_PRELUDE_DIR ?? "../Bend2/prelude");

await generateDungeonConfig(cwd);

const loaded = Bend.Loader.load_book(file, { prelude_dir: preludeDir, strict: true });
const ok = Bend.Core.check_book(loaded.book, {
  show_ok: false,
  write: process.stderr.write.bind(process.stderr),
});

if (!ok) {
  process.exit(1);
}

const html = patchAppRuntime(Bend.ToJS.page(loaded.book, {
  main_name: loaded.main,
  title: path.basename(file, ".bend"),
}));

await Bun.write(out, html);
