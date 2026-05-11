# Internal button content renderer with an inline count badge.

import HTML as HTML
import Midum/Internal/DOM/Button/contents as contents

def contents_with_count(Event: Type, label: String, icon: Midum/Button/Icon, count: String) -> HTML(Event):
  <span>
    {contents(Event, label, icon)}
    <span class="bc-btn-catoon-count__badge">{text{count}}</span>
  </span>
