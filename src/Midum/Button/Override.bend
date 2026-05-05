# Public per-instance button overrides.
#
# These stay flat on purpose so the public API avoids nested state{disabled{}}
# style payloads.

type Override {
  icon_off{}
  icon_left{src: String}
  icon_right{src: String}
  shape_square{}
  shape_rounded{}
  width_fit{}
  width_wide{}
  width_full{}
  state_enabled{}
  state_disabled{}
  catoon_palette{light: String, mid: String, dark: String}
}
