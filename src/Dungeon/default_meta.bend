import /Dungeon/Meta as Meta
import /Dungeon/config as config
import /Dungeon/profile_helpers/default_hero_profiles as default_hero_profiles

def default_meta() -> Meta:
  meta{0, 1, 0, [], [], default_hero_profiles(config())}
