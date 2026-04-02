# Internal DOM layout renderer for Midum.
#
# Layout owns placement and simple grouping. The public API remains one
# primitive, while the DOM renderer maps each closed choice to a CSS class.

import /HTML/

def position_class(position: Midum/Layout/Position) -> String:
  match position:
    case top_left{}:
      "bc-layout-pos-top-left"
    case top{}:
      "bc-layout-pos-top"
    case top_right{}:
      "bc-layout-pos-top-right"
    case left{}:
      "bc-layout-pos-left"
    case center{}:
      "bc-layout-pos-center"
    case right{}:
      "bc-layout-pos-right"
    case bottom_left{}:
      "bc-layout-pos-bottom-left"
    case bottom{}:
      "bc-layout-pos-bottom"
    case bottom_right{}:
      "bc-layout-pos-bottom-right"

def flow_class(flow: Midum/Layout/Flow) -> String:
  match flow:
    case row{}:
      "bc-layout-flow-row"
    case column{}:
      "bc-layout-flow-column"

def gap_class(gap: Midum/Layout/Gap) -> String:
  match gap:
    case none{}:
      "bc-layout-gap-none"
    case sm{}:
      "bc-layout-gap-sm"
    case md{}:
      "bc-layout-gap-md"
    case lg{}:
      "bc-layout-gap-lg"

def box_class(position: Midum/Layout/Position, flow: Midum/Layout/Flow, gap: Midum/Layout/Gap) -> String:
  "bc-layout-box " ++ position_class(position) ++ " " ++ flow_class(flow) ++ " " ++ gap_class(gap)

def box(Event: Type, cfg: Midum/Layout/Config, body: HTML(Event)) -> HTML(Event):
  match cfg:
    case layout{position, flow, gap}:
      <div class={box_class(position, flow, gap)}>
        <div>
          {body}
        </div>
      </div>

def overlay(Event: Type, layers: List(HTML(Event))) -> HTML(Event):
  <div class="bc-layout-overlay">
    {...layers}
  </div>

def stack_class(flow: Midum/Layout/Flow, gap: Midum/Layout/Gap) -> String:
  "bc-layout-stack " ++ flow_class(flow) ++ " " ++ gap_class(gap)

def stack(Event: Type, flow: Midum/Layout/Flow, gap: Midum/Layout/Gap, kids: List(HTML(Event))) -> HTML(Event):
  <div class={stack_class(flow, gap)}>
    {...kids}
  </div>

def css() -> String:
  "
  .bc-layout-box {
    box-sizing: border-box;
    display: flex;
    flex: 1 1 auto;
    width: 100%;
    max-width: 100%;
    height: 100%;
  }

  .bc-screen > .bc-layout-box {
    min-height: 100vh;
    padding: 24px;
  }

  .bc-layout-box > div {
    display: inline-flex;
    box-sizing: border-box;
    max-width: 100%;
  }

  .bc-layout-overlay {
    position: relative;
    box-sizing: border-box;
    width: 100%;
    height: 100%;
    min-height: 100%;
  }

  .bc-screen > .bc-layout-overlay {
    min-height: 100vh;
  }

  .bc-layout-overlay > .bc-layout-box {
    position: absolute;
    inset: 0;
    padding: 24px;
    pointer-events: none;
  }

  .bc-layout-overlay > .bc-layout-box > div {
    pointer-events: auto;
  }

  .bc-layout-stack {
    display: inline-flex;
    box-sizing: border-box;
    max-width: 100%;
  }

  .bc-layout-pos-top-left {
    justify-content: flex-start;
    align-items: flex-start;
  }

  .bc-layout-pos-top {
    justify-content: center;
    align-items: flex-start;
  }

  .bc-layout-pos-top-right {
    justify-content: flex-end;
    align-items: flex-start;
  }

  .bc-layout-pos-left {
    justify-content: flex-start;
    align-items: center;
  }

  .bc-layout-pos-center {
    justify-content: center;
    align-items: center;
  }

  .bc-layout-pos-right {
    justify-content: flex-end;
    align-items: center;
  }

  .bc-layout-pos-bottom-left {
    justify-content: flex-start;
    align-items: flex-end;
  }

  .bc-layout-pos-bottom {
    justify-content: center;
    align-items: flex-end;
  }

  .bc-layout-pos-bottom-right {
    justify-content: flex-end;
    align-items: flex-end;
  }

  .bc-layout-flow-row > div {
    flex-direction: row;
    align-items: center;
    gap: var(--bc-layout-gap);
  }

  .bc-layout-flow-column > div {
    flex-direction: column;
    align-items: center;
    gap: var(--bc-layout-gap);
  }

  .bc-layout-stack.bc-layout-flow-row {
    flex-direction: row;
    align-items: center;
    gap: var(--bc-layout-gap);
  }

  .bc-layout-stack.bc-layout-flow-column {
    flex-direction: column;
    align-items: center;
    gap: var(--bc-layout-gap);
  }

  .bc-layout-gap-none {
    --bc-layout-gap: 0px;
  }

  .bc-layout-gap-sm {
    --bc-layout-gap: 8px;
  }

  .bc-layout-gap-md {
    --bc-layout-gap: 16px;
  }

  .bc-layout-gap-lg {
    --bc-layout-gap: 24px;
  }
  "
