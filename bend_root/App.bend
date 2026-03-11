type App {
  app{
    State: Type,
    Event: Type,
    init: State,
    render: State -> HTML(Event),
    on_event: Event -> State -> State
  }
}
