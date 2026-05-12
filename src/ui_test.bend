import App as App
import HTML as HTML
import Midum/screen as screen
import Midum/Card/neutral as card_neutral

type UiTestState {
  ui_test_state{}
}

type UiTestEvent {
  ui_test_click{}
}

init : App/Update(UiTestState, UiTestEvent) =
  update{ui_test_state{}, none{}}

def on_event(+evt: UiTestEvent, state: UiTestState) -> App/Update(UiTestState, UiTestEvent):
  update{state, none{}}

def yellow_src() -> String:
  "../assets/ui-test/button/button-main-yellow.png"

def gray_src() -> String:
  "../assets/ui-test/button/button-main-gray.png"

def nine_button(label: String, src: String, source_left: Nat, source_right: Nat, source_top: Nat, source_bottom: Nat, target_left: Nat, target_right: Nat, target_top: Nat, target_bottom: Nat) -> HTML(UiTestEvent):
  card_neutral(
    UiTestEvent,
    <span>{text{label}}</span>,
    [
      padding_lg{},
      background_none{},
      border_none{},
      radius_square{},
      surface_image_sized{
        src,
        source_left,
        source_right,
        source_top,
        source_bottom,
        target_left,
        target_right,
        target_top,
        target_bottom
      }
    ]
  )

def yellow_button() -> HTML(UiTestEvent):
  nine_button("Play Test", yellow_src(), 24n, 24n, 50n, 50n, 12n, 12n, 24n, 24n)

def gray_button() -> HTML(UiTestEvent):
  nine_button("Disabled Style", gray_src(), 24n, 24n, 50n, 50n, 12n, 12n, 24n, 24n)

def render(+state: UiTestState) -> HTML(UiTestEvent):
  screen(
    UiTestEvent,
    <div>
      {yellow_button()}
      {gray_button()}
    </div>
  )

main : App =
  app{UiTestState, UiTestEvent, init, render, on_event, none{}}
