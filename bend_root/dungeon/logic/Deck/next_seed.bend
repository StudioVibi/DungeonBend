def next_seed(seed: U32) -> U32:
  value = (seed * 1664525) + 1013904223;
  match value === 0:
    case 0:
      value
    case _:
      1
