type HTML(Event: Type) {
  text{value: String}
  node{tag: String, attrs: List(Attr(Event)), kids: List(HTML(Event))}
}
