import Midum/Internal/DOM/Button/catoon_base_css as button_catoon_base_css
import Midum/Internal/DOM/Button/catoon_count_css as button_catoon_count_css
import Midum/Internal/DOM/Button/catoon_disabled_css as button_catoon_disabled_css
import Midum/Internal/DOM/Button/catoon_preset_css as button_catoon_preset_css
import Midum/Internal/DOM/Button/catoon_shine_css as button_catoon_shine_css
import Midum/Internal/DOM/Button/catoon_size_css as button_catoon_size_css
import Midum/Internal/DOM/Button/catoon_slice_css as button_catoon_slice_css

def catoon_css() -> String:
  button_catoon_base_css()
  ++ button_catoon_preset_css()
  ++ button_catoon_slice_css()
  ++ button_catoon_shine_css()
  ++ button_catoon_size_css()
  ++ button_catoon_disabled_css()
  ++ button_catoon_count_css()
