def append(a: String, b: String) -> String:
  match a:
    case []:
      b
    case h<>t:
      h<>append(t, b)
