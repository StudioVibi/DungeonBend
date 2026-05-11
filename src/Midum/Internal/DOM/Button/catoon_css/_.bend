import Midum/Internal/DOM/Button/catoon_base_css as button_catoon_base_css
import Midum/Internal/DOM/Button/catoon_count_css as button_catoon_count_css
import Midum/Internal/DOM/Button/catoon_preset_css as button_catoon_preset_css
import Midum/Internal/DOM/Button/catoon_size_css as button_catoon_size_css

def catoon_css() -> String:
  button_catoon_base_css()
  ++ button_catoon_size_css()
  ++ button_catoon_preset_css()
  ++ button_catoon_count_css()
