var spriteMap = {
  hero_knight: new URL("../../assets/hero.svg", import.meta.url).href,
  monster_slime: new URL("../../assets/mob1.png", import.meta.url).href,
  monster_ghoul: new URL("../../assets/mob2.png", import.meta.url).href,
  monster_shade: new URL("../../assets/mob3.png", import.meta.url).href,
  monster_brute: new URL("../../assets/mob4.png", import.meta.url).href,
  sword_bronze: new URL("../../assets/sword1.png", import.meta.url).href,
  sword_iron: new URL("../../assets/sword2.png", import.meta.url).href,
  sword_relic: new URL("../../assets/sword3.png", import.meta.url).href,
  potion_small: new URL("../../assets/potion.png", import.meta.url).href,
  gold_drop: new URL("../../assets/drop-gold-chest.png", import.meta.url).href,
} as const;

export function resolveSprite(key: string): string {
  if (key in spriteMap) {
    return spriteMap[key as keyof typeof spriteMap];
  }
  return "";
}
