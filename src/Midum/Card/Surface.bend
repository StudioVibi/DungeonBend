# Internal surface track for card{...}.

type Surface {
  surface_off{}
  surface_image{
    src: String,
    source_left: Nat,
    source_right: Nat,
    source_top: Nat,
    source_bottom: Nat,
    target_left: Nat,
    target_right: Nat,
    target_top: Nat,
    target_bottom: Nat,
  }
}
