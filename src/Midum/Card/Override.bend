# Public per-instance card overrides.
#
# These stay flat so the card surface matches the button and text override
# style.

type Override {
  padding_none{}
  padding_sm{}
  padding_md{}
  padding_lg{}
  background_none{}
  border_none{}
  radius_square{}
  radius_rounded{}
  gradient{}
  surface_image{src: String, left: Nat, right: Nat, top: Nat, bottom: Nat}
  surface_image_sized{
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
