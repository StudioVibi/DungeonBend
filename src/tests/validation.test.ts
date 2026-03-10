import { describe, expect, test } from "bun:test";

import { defaultMetaState, loadMetaState, saveMetaState } from "../game/storage";
import { normalizeBalanceData } from "../game/normalize";
import { parseBalanceData } from "../game/validation";

var rawBalance = await Bun.file(new URL("../../public/data/balance.json", import.meta.url)).json() as Record<string, unknown>;
var normalized = normalizeBalanceData(parseBalanceData(rawBalance));

describe("validation and storage", () => {
  test("invalid deck totals are rejected", () => {
    var broken = structuredClone(rawBalance) as Record<string, unknown>;
    var deck = broken.deck as { entries: { count: number }[] };
    deck.entries[0].count = 99;

    expect(() => parseBalanceData(broken)).toThrow("count total must equal deck.baseSize");
  });

  test("meta state round-trips through localStorage", () => {
    var store = new Map<string, string>();
    (globalThis as { window?: unknown }).window = {
      localStorage: {
        getItem(key: string) {
          return store.get(key) ?? null;
        },
        setItem(key: string, value: string) {
          store.set(key, value);
        },
      },
    };

    var meta = defaultMetaState(normalized);
    var saved = { ...meta, gold: 42, heroLevel: 2 };
    saveMetaState(saved);

    expect(loadMetaState(normalized)).toEqual(saved);
  });
});
