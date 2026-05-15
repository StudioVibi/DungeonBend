import HTML as HTML
import Dungeon/DungeonEvent as DungeonEvent

def render(role_class: String, leading: HTML(DungeonEvent), content: HTML(DungeonEvent)) -> HTML(DungeonEvent):
  <header class={"topbar topbar--menu-ui " ++ role_class}>
    <div class="topbar__slot topbar__slot--leading">
      {leading}
    </div>
    <div class="topbar__content">
      {content}
    </div>
  </header>
