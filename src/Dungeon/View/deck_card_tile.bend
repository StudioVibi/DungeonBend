import HTML as HTML
import Dungeon/CardRef as CardRef
import Dungeon/DungeonEvent as DungeonEvent
import Dungeon/View/assets_and_labels/_card_sprite as _card_sprite
import Dungeon/View/assets_and_labels/_card_name as _card_name

def render_tile(card: CardRef, modifier: String, count_label: String, click: DungeonEvent) -> HTML(DungeonEvent):
  <button class={"deck-tile" ++ modifier} type="button" on_click={click}>
    <span class="deck-tile__art-wrap">
      <img class="deck-tile__art" src={_card_sprite(card)} alt={_card_name(card)} />
    </span>
    {_count_badge(count_label)}
  </button>

def _count_badge(label: String) -> HTML(DungeonEvent):
  match String/eq(label, ""):
    case true{}:
      text{""}
    case false{}:
      <span class="deck-tile__badge">{text{label}}</span>

def render_tile_static(card: CardRef, modifier: String, count_label: String) -> HTML(DungeonEvent):
  <div class={"deck-tile deck-tile--static" ++ modifier}>
    <span class="deck-tile__art-wrap">
      <img class="deck-tile__art" src={_card_sprite(card)} alt={_card_name(card)} />
    </span>
    {_count_badge(count_label)}
  </div>

def render_empty(click: DungeonEvent, modifier: String) -> HTML(DungeonEvent):
  <button class={"deck-tile deck-tile--empty" ++ modifier} type="button" on_click={click}>
    <span class="deck-tile__plus">+</span>
  </button>

def render_empty_static() -> HTML(DungeonEvent):
  <div class="deck-tile deck-tile--empty deck-tile--static">
    <span class="deck-tile__plus">+</span>
  </div>
