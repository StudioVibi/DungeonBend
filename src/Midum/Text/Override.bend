# Public per-instance text overrides.
#
# Keep these flat so the call site matches the button override style.

type Override(Event: Type) {
  link{href: String}
  action{evt: Event}
  color_primary{}
  color_secondary{}
  color_neutral{}
  color_success{}
  color_warning{}
  color_danger{}
}
