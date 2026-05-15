import HTML as HTML
import Dungeon/DungeonEvent as DungeonEvent
import Dungeon/View/menu_screen/_menu_screen_frame as _menu_screen_frame
import Dungeon/View/menu_topbar/render as menu_topbar
import Dungeon/View/action_button/back_button as action_back_button

def render(desktop_back: DungeonEvent, mobile_back: DungeonEvent, trailing: HTML(DungeonEvent), mobile_title: HTML(DungeonEvent), actions: List(HTML(DungeonEvent)), body: HTML(DungeonEvent)) -> HTML(DungeonEvent):
  _menu_screen_frame(_chrome_header(desktop_back, trailing, mobile_title), body, _chrome_footer(mobile_back, actions))

def _chrome_header(back_event: DungeonEvent, trailing: HTML(DungeonEvent), mobile_title: HTML(DungeonEvent)) -> HTML(DungeonEvent):
  <div class="deck-chrome-headers">
    {menu_topbar("topbar--deck-chrome topbar--deck-chrome-desktop", _back_button(back_event), trailing)}
    {menu_topbar("topbar--deck-chrome topbar--deck-chrome-mobile", text{""}, mobile_title)}
  </div>

def _chrome_footer(back_event: DungeonEvent, actions: List(HTML(DungeonEvent))) -> HTML(DungeonEvent):
  <div class="deck-chrome-footer">
    <div class="deck-chrome-footer__back">
      {_back_button(back_event)}
    </div>
    {..._wrap_actions(actions)}
  </div>

def _wrap_actions(actions: List(HTML(DungeonEvent))) -> List(HTML(DungeonEvent)):
  match actions:
    case []:
      []
    case head<>rest:
      _wrap_action(head)<>_wrap_actions(rest)

def _wrap_action(node: HTML(DungeonEvent)) -> HTML(DungeonEvent):
  <div class="deck-chrome-footer__action">{node}</div>

def _back_button(back_event: DungeonEvent) -> HTML(DungeonEvent):
  <div class="menu-club-btn-wrap menu-club-btn-wrap--fit">
    {action_back_button(DungeonEvent, back_event, "BACK")}
  </div>
