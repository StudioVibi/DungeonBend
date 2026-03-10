import { describe, expect, test } from "bun:test";

import {
  applySwipe,
  decodeMeta,
  decodeRun,
  encodeMeta,
  encodeRun,
  startRun,
  upgradeHero,
} from "../game/core";
import { normalizeBalanceData } from "../game/normalize";
import type { CoreBoardTile, MetaState, NormalizedBalance, RunState } from "../game/types";
import { parseBalanceData } from "../game/validation";

var rawBalance = await Bun.file(new URL("../../public/data/balance.json", import.meta.url)).json();
var baseBalance = normalizeBalanceData(parseBalanceData(rawBalance));

function cloneBalance(): NormalizedBalance {
  return structuredClone(baseBalance);
}

function emptyBoard(): CoreBoardTile[] {
  return Array.from({ length: 9 }, () => ({ tag: "none" } as CoreBoardTile));
}

function makeRun(overrides: Partial<RunState> = {}): RunState {
  return {
    dungeonLevel: 1,
    heroHp: 10,
    heroMaxHp: 10,
    heroIndex: 4,
    weapon: { tag: "none" },
    board: emptyBoard(),
    deckBlueprint: [{ kind: 1, ref: 0, count: 1 }],
    drawCounts: [{ kind: 1, ref: 0, count: 1 }],
    remaining: 1,
    capacity: 20,
    seed: 1,
    status: "running",
    ...overrides,
  };
}

describe("bend engine bridge", () => {
  test("startRun seeds the hero in the center and fills the other slots", () => {
    var balance = cloneBalance();
    var run = startRun(balance, { heroId: balance.hero.id, heroLevel: 0, gold: 0 }, 1);
    var populated = run.board.filter(tile => tile.tag !== "none");

    expect(run.heroIndex).toBe(4);
    expect(populated).toHaveLength(8);
    expect(run.remaining).toBe(11);
    expect(run.capacity).toBe(20);
  });

  test("upgradeHero spends gold and increases hero level when affordable", () => {
    var balance = cloneBalance();
    var next = upgradeHero(balance, {
      heroId: balance.hero.id,
      heroLevel: 0,
      gold: 25,
    });

    expect(next.heroLevel).toBe(1);
    expect(next.gold).toBe(5);
  });

  test("upgradeHero does nothing when the player cannot afford the next step", () => {
    var balance = cloneBalance();
    var meta = {
      heroId: balance.hero.id,
      heroLevel: 0,
      gold: 5,
    };

    expect(upgradeHero(balance, meta)).toEqual(meta);
  });

  test("unarmed combat wins when hero hp is greater than monster hp", () => {
    var balance = cloneBalance();
    var board = emptyBoard();
    board[1] = { tag: "monster", ref: 0, hp: 6 };
    var result = applySwipe(
      balance,
      { heroId: balance.hero.id, heroLevel: 0, gold: 0 },
      makeRun({ board }),
      "up",
    );

    expect(result.run.heroIndex).toBe(4);
    expect(result.run.heroHp).toBe(4);
    expect(result.run.board[1]).toEqual({ tag: "gold", amount: balance.monsterOrder[0].goldDrop });
  });

  test("equal unarmed combat triggers game over", () => {
    var balance = cloneBalance();
    var board = emptyBoard();
    board[1] = { tag: "monster", ref: 0, hp: 3 };
    var result = applySwipe(
      balance,
      { heroId: balance.hero.id, heroLevel: 0, gold: 0 },
      makeRun({ board, heroHp: 3 }),
      "up",
    );

    expect(result.run.status).toBe("game_over");
    expect(result.run.heroHp).toBe(0);
  });

  test("lower unarmed combat also triggers game over", () => {
    var balance = cloneBalance();
    var board = emptyBoard();
    board[1] = { tag: "monster", ref: 1, hp: 8 };
    var result = applySwipe(
      balance,
      { heroId: balance.hero.id, heroLevel: 0, gold: 0 },
      makeRun({ board, heroHp: 4 }),
      "up",
    );

    expect(result.run.status).toBe("game_over");
    expect(result.run.heroHp).toBe(0);
    expect(result.run.heroIndex).toBe(4);
  });

  test("weapon greater damage kills the monster and keeps the remaining weapon damage", () => {
    var balance = cloneBalance();
    var board = emptyBoard();
    board[1] = { tag: "monster", ref: 0, hp: 3 };
    var result = applySwipe(
      balance,
      { heroId: balance.hero.id, heroLevel: 0, gold: 0 },
      makeRun({
        board,
        heroHp: 8,
        weapon: { tag: "weapon", ref: 0, dmg: 5 },
      }),
      "up",
    );

    expect(result.run.heroHp).toBe(8);
    expect(result.run.weapon).toEqual({ tag: "weapon", ref: 0, dmg: 2 });
    expect(result.run.board[1]).toEqual({ tag: "gold", amount: balance.monsterOrder[0].goldDrop });
  });

  test("weapon equal damage kills the monster and breaks the weapon", () => {
    var balance = cloneBalance();
    var board = emptyBoard();
    board[1] = { tag: "monster", ref: 1, hp: 5 };
    var result = applySwipe(
      balance,
      { heroId: balance.hero.id, heroLevel: 0, gold: 0 },
      makeRun({
        board,
        heroHp: 8,
        weapon: { tag: "weapon", ref: 0, dmg: 5 },
      }),
      "up",
    );

    expect(result.run.weapon).toEqual({ tag: "none" });
    expect(result.run.board[1]).toEqual({ tag: "gold", amount: balance.monsterOrder[1].goldDrop });
  });

  test("weapon lower damage leaves the monster alive, breaks the weapon, and does not move or spawn", () => {
    var balance = cloneBalance();
    var board = emptyBoard();
    board[1] = { tag: "monster", ref: 2, hp: 7 };
    board[7] = { tag: "potion", ref: 0, heal: 4 };
    var run = makeRun({
      board,
      heroHp: 9,
      weapon: { tag: "weapon", ref: 0, dmg: 5 },
      remaining: 1,
      drawCounts: [{ kind: 2, ref: 0, count: 1 }],
      deckBlueprint: [{ kind: 2, ref: 0, count: 1 }],
      seed: 5,
    });
    var result = applySwipe(
      balance,
      { heroId: balance.hero.id, heroLevel: 0, gold: 0 },
      run,
      "up",
    );

    expect(result.run.heroIndex).toBe(4);
    expect(result.run.remaining).toBe(1);
    expect(result.run.seed).toBe(5);
    expect(result.run.weapon).toEqual({ tag: "none" });
    expect(result.run.board[1]).toEqual({ tag: "monster", ref: 2, hp: 2 });
    expect(result.run.board[7]).toEqual({ tag: "potion", ref: 0, heal: 4 });
  });

  test("monster loot requires a second swipe to collect and move", () => {
    var balance = cloneBalance();
    var board = emptyBoard();
    board[1] = { tag: "gold", amount: 3 };
    board[7] = { tag: "sword", ref: 0, dmg: 5 };
    var result = applySwipe(
      balance,
      { heroId: balance.hero.id, heroLevel: 0, gold: 1 },
      makeRun({
        board,
        seed: 5,
      }),
      "up",
    );

    expect(result.meta.gold).toBe(4);
    expect(result.run.heroIndex).toBe(1);
    expect(result.run.board[4]).toEqual({ tag: "sword", ref: 0, dmg: 5 });
    expect(result.run.board[7].tag).toBe("sword");
  });

  test("potion healing is capped by hero max hp", () => {
    var balance = cloneBalance();
    var board = emptyBoard();
    board[3] = { tag: "potion", ref: 0, heal: 4 };
    var result = applySwipe(
      balance,
      { heroId: balance.hero.id, heroLevel: 0, gold: 0 },
      makeRun({
        board,
        heroHp: 8,
        heroMaxHp: 10,
      }),
      "left",
    );

    expect(result.run.heroHp).toBe(10);
    expect(result.run.heroIndex).toBe(3);
  });

  test("moving into an item shifts the opposite card and spawns a new tile", () => {
    var balance = cloneBalance();
    var board = emptyBoard();
    board[3] = { tag: "gold", amount: 2 };
    board[5] = { tag: "potion", ref: 0, heal: 4 };
    var result = applySwipe(
      balance,
      { heroId: balance.hero.id, heroLevel: 0, gold: 0 },
      makeRun({ board, seed: 5 }),
      "left",
    );

    expect(result.meta.gold).toBe(2);
    expect(result.run.heroIndex).toBe(3);
    expect(result.run.board[4]).toEqual({ tag: "potion", ref: 0, heal: 4 });
    expect(result.run.board[5].tag).toBe("sword");
  });

  test("deck exhaustion refills from the blueprint and increases dungeon level", () => {
    var balance = cloneBalance();
    var board = emptyBoard();
    board[1] = { tag: "gold", amount: 1 };
    var result = applySwipe(
      balance,
      { heroId: balance.hero.id, heroLevel: 0, gold: 0 },
      makeRun({
        board,
        remaining: 0,
        drawCounts: [],
        deckBlueprint: [{ kind: 1, ref: 0, count: 1 }],
        capacity: 2,
      }),
      "up",
    );

    expect(result.run.dungeonLevel).toBe(2);
    expect(result.run.board[7].tag).toBe("sword");
  });

  test("run state survives encode/decode without losing information", () => {
    var run = makeRun({
      dungeonLevel: 2,
      heroHp: 7,
      heroMaxHp: 12,
      heroIndex: 1,
      weapon: { tag: "weapon", ref: 1, dmg: 7 },
      board: [
        { tag: "monster", ref: 0, hp: 3 },
        { tag: "none" },
        { tag: "gold", amount: 4 },
        { tag: "potion", ref: 0, heal: 4 },
        { tag: "none" },
        { tag: "sword", ref: 1, dmg: 7 },
        { tag: "monster", ref: 2, hp: 9 },
        { tag: "gold", amount: 1 },
        { tag: "monster", ref: 3, hp: 11 },
      ],
      deckBlueprint: [
        { kind: 0, ref: 0, count: 2 },
        { kind: 1, ref: 1, count: 1 },
      ],
      drawCounts: [{ kind: 0, ref: 0, count: 1 }],
      remaining: 1,
      capacity: 20,
      seed: 99,
      status: "running",
    });

    expect(decodeRun(encodeRun(run))).toEqual(run);
  });

  test("meta state survives encode/decode without losing information", () => {
    var meta: MetaState = {
      heroId: "knight",
      heroLevel: 2,
      gold: 41,
    };

    expect(decodeMeta(encodeMeta(meta), meta.heroId)).toEqual(meta);
  });
});
