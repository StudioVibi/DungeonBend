import Dungeon/DeckEntry as DeckEntry
import Dungeon/DeckQuotas as DeckQuotas
import Dungeon/DeckCategory as DeckCategory
import Dungeon/Config as Config
import Dungeon/config as config

def quotas_from_config(cfg: Config) -> DeckQuotas:
  match cfg:
    case config{heroes, monsters, swords, potions, deck, booster_packs, starting_dungeon_level}:
      _quotas_from_entries(deck)

def _quotas_from_entries(entries: List(DeckEntry)) -> DeckQuotas:
  m = category_count(entries, cat_monsters{});
  s = category_count(entries, cat_swords{});
  p = category_count(entries, cat_potions{});
  h = category_count(entries, cat_hero{});
  deck_quotas{m, s, p, h, m + s + p + h}

def deck_quotas_default() -> DeckQuotas:
  quotas_from_config(config())

def quota_for_category(q: DeckQuotas, cat: DeckCategory) -> U32:
  match q cat:
    case deck_quotas{monsters, swords, potions, hero, total} cat_monsters{}:
      monsters
    case deck_quotas{monsters, swords, potions, hero, total} cat_swords{}:
      swords
    case deck_quotas{monsters, swords, potions, hero, total} cat_potions{}:
      potions
    case deck_quotas{monsters, swords, potions, hero, total} cat_hero{}:
      hero

def quotas_total(q: DeckQuotas) -> U32:
  match q:
    case deck_quotas{monsters, swords, potions, hero, total}:
      total

def category_count(entries: List(DeckEntry), cat: DeckCategory) -> U32:
  match entries:
    case []:
      0
    case current<>rest:
      _entry_count_for(current, cat) + category_count(rest, cat)

def _entry_count_for(entry: DeckEntry, cat: DeckCategory) -> U32:
  match entry cat:
    case monster_entry{ref, count} cat_monsters{}:
      count
    case sword_entry{ref, count} cat_swords{}:
      count
    case potion_entry{ref, count} cat_potions{}:
      count
    case hero_entry{count} cat_hero{}:
      count
    case _ _:
      0

def category_label(cat: DeckCategory) -> String:
  match cat:
    case cat_monsters{}:
      "monsters"
    case cat_swords{}:
      "swords"
    case cat_potions{}:
      "potions"
    case cat_hero{}:
      "hero"
