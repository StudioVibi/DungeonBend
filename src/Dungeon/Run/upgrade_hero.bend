import Dungeon/Upgrade as Upgrade
import Dungeon/HeroProfile as HeroProfile
import Dungeon/Meta as Meta
import Dungeon/Config as Config
import Dungeon/Deck/counts_pick/nth_upgrade as nth_upgrade
import Dungeon/hero_helpers/hero_at as hero_at
import Dungeon/hero_helpers/hero_upgrades as hero_upgrades
import Dungeon/profile_helpers/selected_hero as selected_hero
import Dungeon/profile_helpers/profile_for_hero as profile_for_hero
import Dungeon/profile_helpers/update_profile as update_profile
import Dungeon/profile_helpers/meta_gold as meta_gold
import Dungeon/profile_helpers/set_meta_gold as set_meta_gold
import Dungeon/profile_helpers/profile_unlocked as profile_unlocked
import Dungeon/profile_helpers/profile_hero_level as profile_hero_level
import Dungeon/profile_helpers/profile_with_level as profile_with_level

def upgrade_hero(config_value: Config, meta_state: Meta) -> Meta:
  hero_ref = selected_hero(meta_state);
  upgrade_hero_ref(config_value, meta_state, hero_ref)

def upgrade_hero_ref(config_value: Config, meta_state: Meta, hero_ref: U32) -> Meta:
  hero_value = hero_at(config_value, hero_ref);
  profile = profile_for_hero(meta_state, hero_ref);
  _upgrade_from_step(meta_state, hero_ref, profile, nth_upgrade(hero_upgrades(hero_value), profile_hero_level(profile)))

def _upgrade_from_step(meta_state: Meta, hero_ref: U32, profile: HeroProfile, step: Upgrade) -> Meta:
  match profile_unlocked(profile):
    case 0:
      meta_state
    case _:
      match step:
        case upgrade{cost, max_hp}:
          match max_hp:
            case 0:
              meta_state
            case _:
              _upgrade_if_affordable(meta_state, hero_ref, profile, cost)

def _upgrade_if_affordable(meta_state: Meta, hero_ref: U32, profile: HeroProfile, cost: U32) -> Meta:
  _upgrade_if_affordable_flag(meta_gold(meta_state) < cost, meta_state, hero_ref, profile, cost)

def _upgrade_if_affordable_flag(gold_lt_cost: U32, meta_state: Meta, hero_ref: U32, profile: HeroProfile, cost: U32) -> Meta:
  match gold_lt_cost:
    case 0:
      set_meta_gold(
        update_profile(meta_state, hero_ref, profile_with_level(profile, profile_hero_level(profile) + 1)),
        meta_gold(meta_state) - cost
      )
    case _:
      meta_state
