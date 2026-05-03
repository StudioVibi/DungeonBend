import HTML as HTML

def u32_grid(Event: Type, width: U32, height: U32, render: U32 +> U32 +> HTML(Event)) -> List(HTML(Event)):
  _u32_grid_rows(Event, width, height, 0, render)

def _u32_grid_rows(Event: Type, width: U32, height: U32, y: U32, render: U32 +> U32 +> HTML(Event)) -> List(HTML(Event)):
  match y === height:
    case 0:
      _append_html(
        Event,
        _u32_grid_cols(Event, width, y, 0, render),
        _u32_grid_rows(Event, width, height, y + 1, render)
      )
    case _:
      []

def _u32_grid_cols(Event: Type, width: U32, y: U32, x: U32, render: U32 +> U32 +> HTML(Event)) -> List(HTML(Event)):
  match x === width:
    case 0:
      render(x, y) <> _u32_grid_cols(Event, width, y, x + 1, render)
    case _:
      []

def _append_html(Event: Type, left: List(HTML(Event)), right: List(HTML(Event))) -> List(HTML(Event)):
  match left:
    case []:
      right
    case item<>rest:
      item <> _append_html(Event, rest, right)
