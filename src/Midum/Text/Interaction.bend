# Resolved interaction mode for the Midum text layer.

type Interaction(Event: Type) {
  static{}
  navigate{href: String}
  trigger{evt: Event}
}
