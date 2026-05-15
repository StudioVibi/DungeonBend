import HTML as HTML
import Dungeon/DungeonEvent as DungeonEvent
import Midum/Card/neutral as card_neutral
import String/is_empty as string_is_empty

def _card_frame() -> String:
  "assets/ui/characters/selection/card-frame-gray.png"

def _upgrade_arrow() -> String:
  "assets/ui/characters/selection/icon-upgrade-arrow.png"

def _card_overrides() -> List(Midum/Card/Override):
  [
    padding_none{},
    background_none{},
    border_none{},
    radius_square{},
    surface_image_sized{
      _card_frame(),
      18n,
      18n,
      18n,
      18n,
      9n,
      9n,
      9n,
      9n
    }
  ]

def _portrait(portrait_src: String, label: String) -> HTML(DungeonEvent):
  match string_is_empty(portrait_src):
    case true{}:
      text{""}
    case false{}:
      <img class="character-roster-card__portrait" src={portrait_src} alt="" />

def _upgrade_badge(show_upgrade: U32) -> HTML(DungeonEvent):
  match show_upgrade:
    case 0:
      text{""}
    case _:
      <span class="character-roster-card__upgrade db-upgrade-jelly" aria-hidden="true">
        <img class="character-roster-card__upgrade-icon" src={_upgrade_arrow()} alt="" />
      </span>

def render(class_name: String, hero_ref: U32, label: String, portrait_src: String, level_text: String, show_upgrade: U32) -> HTML(DungeonEvent):
  <button class={class_name} type="button" on_click={preview_character{hero_ref}}>
    {card_neutral(
      DungeonEvent,
      <span class="character-roster-card__content">
        <span class="character-roster-card__sr-label">{text{label}}</span>
        <span class="character-roster-card__mask">
          {_portrait(portrait_src, label)}
          <span class="character-roster-card__footer">
            <span class="character-roster-card__level">{text{level_text}}</span>
          </span>
        </span>
        {_upgrade_badge(show_upgrade)}
      </span>,
      _card_overrides()
    )}
  </button>
