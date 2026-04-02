# Public inline inspector config for text.
#
# The call site stays compact while the renderer still receives resolved
# concrete values.

type Config(Event: Type) {
  copy{
    content: String,
    variant: Midum/Text/Variant,
    align: Midum/Text/Align,
    interaction: Midum/Text/Interaction(Event),
    color: Midum/Text/Color,
  }
}
