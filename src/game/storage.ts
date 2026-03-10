import type { MetaState, NormalizedBalance } from "./types";

var STORAGE_KEY = "dungeonbend.meta.v1";

export function defaultMetaState(balance: NormalizedBalance): MetaState {
  return {
    heroId: balance.hero.id,
    heroLevel: 0,
    gold: balance.startingGold,
  };
}

export function loadMetaState(balance: NormalizedBalance): MetaState {
  var fallback = defaultMetaState(balance);
  try {
    var raw = window.localStorage.getItem(STORAGE_KEY);
    if (raw === null) {
      return fallback;
    }
    var parsed = JSON.parse(raw) as Partial<MetaState>;
    if (typeof parsed.heroId !== "string") {
      return fallback;
    }
    if (typeof parsed.heroLevel !== "number" || !Number.isInteger(parsed.heroLevel) || parsed.heroLevel < 0) {
      return fallback;
    }
    if (typeof parsed.gold !== "number" || !Number.isInteger(parsed.gold) || parsed.gold < 0) {
      return fallback;
    }
    return {
      heroId: parsed.heroId,
      heroLevel: parsed.heroLevel,
      gold: parsed.gold,
    };
  } catch {
    return fallback;
  }
}

export function saveMetaState(meta: MetaState): void {
  window.localStorage.setItem(STORAGE_KEY, JSON.stringify(meta));
}
