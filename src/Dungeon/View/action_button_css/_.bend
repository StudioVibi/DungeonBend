import Dungeon/View/action_button_css/base_css as action_button_base_css
import Dungeon/View/action_button_css/disabled_css as action_button_disabled_css
import Dungeon/View/action_button_css/shine_css as action_button_shine_css
import Dungeon/View/action_button_css/size_css as action_button_size_css
import Dungeon/View/action_button_css/slice_css as action_button_slice_css
import Dungeon/View/action_button_css/skin_css as action_button_skin_css
import Dungeon/View/action_button_css/upgrade_css as action_button_upgrade_css

def action_button_css() -> String:
  action_button_base_css()
  ++ action_button_skin_css()
  ++ action_button_slice_css()
  ++ action_button_shine_css()
  ++ action_button_size_css()
  ++ action_button_disabled_css()
  ++ action_button_upgrade_css()
