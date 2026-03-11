type Attr(Event: Type) {
  attr{nam: String, val: String}
  style{nam: String, val: String}
  on_click{msg: Event}
  on_input{fun: String -> Event}
  on_key_down{fun: U32 -> Event}
  every_ms{ms: U32, msg: Event}
}
