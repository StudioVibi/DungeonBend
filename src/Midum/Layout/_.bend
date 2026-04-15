# Public layout API for Midum.
#
# Layout stays separate from component authoring. It covers document flow and
# canvas anchoring without exposing renderer-specific HTML.

import /HTML/
import /Midum/Layout/Align
import /Midum/Layout/Config
import /Midum/Layout/ContainerConfig
import /Midum/Layout/FrameConfig
import /Midum/Layout/Flow
import /Midum/Layout/Gap
import /Midum/Layout/MaxWidth
import /Midum/Layout/PageConfig
import /Midum/Layout/StackConfig
import /Midum/Internal/DOM/Layout/Arrangement
import /Midum/Internal/DOM/Layout/box as dom_box
import /Midum/Internal/DOM/Layout/frame as dom_frame
import /Midum/Internal/DOM/Layout/group_stack as dom_stack
import /Midum/Internal/DOM/Layout/overlay as dom_overlay
import /Midum/Internal/DOM/Layout/render_container as dom_container
import /Midum/Internal/DOM/Layout/render_document_stack as dom_document_stack
import /Midum/Internal/DOM/Layout/render_page as dom_page

def with_frame_width(cfg: Midum/Layout/FrameConfig, next_width: Midum/Layout/Width) -> Midum/Layout/FrameConfig:
  match cfg:
    case frame{width, height, inset}:
      frame{width: next_width, height, inset}

def with_frame_height(cfg: Midum/Layout/FrameConfig, next_height: Midum/Layout/Height) -> Midum/Layout/FrameConfig:
  match cfg:
    case frame{width, height, inset}:
      frame{width, height: next_height, inset}

def with_frame_inset(cfg: Midum/Layout/FrameConfig, next_inset: Midum/Layout/Inset) -> Midum/Layout/FrameConfig:
  match cfg:
    case frame{width, height, inset}:
      frame{width, height, inset: next_inset}

def apply_frame_override(cfg: Midum/Layout/FrameConfig, override: Midum/Layout/Override) -> Midum/Layout/FrameConfig:
  match override:
    case width_fit{}:
      with_frame_width(cfg, fit{})
    case width_full{}:
      with_frame_width(cfg, full{})
    case width_px{value}:
      with_frame_width(cfg, px{value})
    case height_fit{}:
      with_frame_height(cfg, fit{})
    case height_full{}:
      with_frame_height(cfg, full{})
    case height_px{value}:
      with_frame_height(cfg, px{value})
    case inset_none{}:
      with_frame_inset(cfg, none{})
    case inset_sm{}:
      with_frame_inset(cfg, sm{})
    case inset_md{}:
      with_frame_inset(cfg, md{})
    case inset_lg{}:
      with_frame_inset(cfg, lg{})
    case max_width_px{value}:
      cfg
    case direction_column{}:
      cfg
    case direction_row{}:
      cfg
    case gap_none{}:
      cfg
    case gap_sm{}:
      cfg
    case gap_md{}:
      cfg
    case gap_lg{}:
      cfg
    case align_start{}:
      cfg
    case align_center{}:
      cfg
    case align_end{}:
      cfg
    case align_stretch{}:
      cfg

def apply_frame_overrides(cfg: Midum/Layout/FrameConfig, overrides: List(Midum/Layout/Override)) -> Midum/Layout/FrameConfig:
  match overrides:
    case []:
      cfg
    case override<>rest:
      apply_frame_overrides(apply_frame_override(cfg, override), rest)

def frame_config(overrides: List(Midum/Layout/Override)) -> Midum/Layout/FrameConfig:
  apply_frame_overrides(frame{width: fit{}, height: fit{}, inset: md{}}, overrides)

def apply_page_override(cfg: Midum/Layout/PageConfig, override: Midum/Layout/Override) -> Midum/Layout/PageConfig:
  match override:
    case inset_none{}:
      page_layout{inset: none{}}
    case inset_sm{}:
      page_layout{inset: sm{}}
    case inset_md{}:
      page_layout{inset: md{}}
    case inset_lg{}:
      page_layout{inset: lg{}}
    case width_fit{}:
      cfg
    case width_full{}:
      cfg
    case width_px{value}:
      cfg
    case height_fit{}:
      cfg
    case height_full{}:
      cfg
    case height_px{value}:
      cfg
    case max_width_px{value}:
      cfg
    case direction_column{}:
      cfg
    case direction_row{}:
      cfg
    case gap_none{}:
      cfg
    case gap_sm{}:
      cfg
    case gap_md{}:
      cfg
    case gap_lg{}:
      cfg
    case align_start{}:
      cfg
    case align_center{}:
      cfg
    case align_end{}:
      cfg
    case align_stretch{}:
      cfg

def apply_page_overrides(cfg: Midum/Layout/PageConfig, overrides: List(Midum/Layout/Override)) -> Midum/Layout/PageConfig:
  match overrides:
    case []:
      cfg
    case override<>rest:
      apply_page_overrides(apply_page_override(cfg, override), rest)

def page_config(overrides: List(Midum/Layout/Override)) -> Midum/Layout/PageConfig:
  apply_page_overrides(page_layout{inset: md{}}, overrides)

def apply_container_override(cfg: Midum/Layout/ContainerConfig, override: Midum/Layout/Override) -> Midum/Layout/ContainerConfig:
  match override:
    case max_width_px{value}:
      container_layout{max_width: max_width_px_value{value}}
    case width_fit{}:
      cfg
    case width_full{}:
      cfg
    case width_px{value}:
      cfg
    case height_fit{}:
      cfg
    case height_full{}:
      cfg
    case height_px{value}:
      cfg
    case inset_none{}:
      cfg
    case inset_sm{}:
      cfg
    case inset_md{}:
      cfg
    case inset_lg{}:
      cfg
    case direction_column{}:
      cfg
    case direction_row{}:
      cfg
    case gap_none{}:
      cfg
    case gap_sm{}:
      cfg
    case gap_md{}:
      cfg
    case gap_lg{}:
      cfg
    case align_start{}:
      cfg
    case align_center{}:
      cfg
    case align_end{}:
      cfg
    case align_stretch{}:
      cfg

def apply_container_overrides(cfg: Midum/Layout/ContainerConfig, overrides: List(Midum/Layout/Override)) -> Midum/Layout/ContainerConfig:
  match overrides:
    case []:
      cfg
    case override<>rest:
      apply_container_overrides(apply_container_override(cfg, override), rest)

def container_config(overrides: List(Midum/Layout/Override)) -> Midum/Layout/ContainerConfig:
  apply_container_overrides(container_layout{max_width: max_width_none{}}, overrides)

def with_stack_flow(cfg: Midum/Layout/StackConfig, next_flow: Midum/Layout/Flow) -> Midum/Layout/StackConfig:
  match cfg:
    case document_stack_layout{flow, gap, align}:
      document_stack_layout{flow: next_flow, gap, align}

def with_stack_gap(cfg: Midum/Layout/StackConfig, next_gap: Midum/Layout/Gap) -> Midum/Layout/StackConfig:
  match cfg:
    case document_stack_layout{flow, gap, align}:
      document_stack_layout{flow, gap: next_gap, align}

def with_stack_align(cfg: Midum/Layout/StackConfig, next_align: Midum/Layout/Align) -> Midum/Layout/StackConfig:
  match cfg:
    case document_stack_layout{flow, gap, align}:
      document_stack_layout{flow, gap, align: next_align}

def apply_stack_override(cfg: Midum/Layout/StackConfig, override: Midum/Layout/Override) -> Midum/Layout/StackConfig:
  match override:
    case direction_column{}:
      with_stack_flow(cfg, column{})
    case direction_row{}:
      with_stack_flow(cfg, row{})
    case gap_none{}:
      with_stack_gap(cfg, none{})
    case gap_sm{}:
      with_stack_gap(cfg, sm{})
    case gap_md{}:
      with_stack_gap(cfg, md{})
    case gap_lg{}:
      with_stack_gap(cfg, lg{})
    case align_start{}:
      with_stack_align(cfg, align_start_value{})
    case align_center{}:
      with_stack_align(cfg, align_center_value{})
    case align_end{}:
      with_stack_align(cfg, align_end_value{})
    case align_stretch{}:
      with_stack_align(cfg, align_stretch_value{})
    case width_fit{}:
      cfg
    case width_full{}:
      cfg
    case width_px{value}:
      cfg
    case height_fit{}:
      cfg
    case height_full{}:
      cfg
    case height_px{value}:
      cfg
    case inset_none{}:
      cfg
    case inset_sm{}:
      cfg
    case inset_md{}:
      cfg
    case inset_lg{}:
      cfg
    case max_width_px{value}:
      cfg

def apply_stack_overrides(cfg: Midum/Layout/StackConfig, overrides: List(Midum/Layout/Override)) -> Midum/Layout/StackConfig:
  match overrides:
    case []:
      cfg
    case override<>rest:
      apply_stack_overrides(apply_stack_override(cfg, override), rest)

def stack_config(overrides: List(Midum/Layout/Override)) -> Midum/Layout/StackConfig:
  apply_stack_overrides(document_stack_layout{flow: column{}, gap: md{}, align: align_stretch_value{}}, overrides)

def overlay(Event: Type, layers: List(HTML(Event))) -> HTML(Event):
  dom_overlay(Event, layers)

def frame(Event: Type, body: HTML(Event), overrides: List(Midum/Layout/Override)) -> HTML(Event):
  dom_frame(Event, frame_config(overrides), body)

def page(Event: Type, body: HTML(Event), overrides: List(Midum/Layout/Override)) -> HTML(Event):
  dom_page(Event, page_config(overrides), body)

def container(Event: Type, body: HTML(Event), overrides: List(Midum/Layout/Override)) -> HTML(Event):
  dom_container(Event, container_config(overrides), body)

def stack(Event: Type, kids: List(HTML(Event)), overrides: List(Midum/Layout/Override)) -> HTML(Event):
  dom_document_stack(Event, stack_config(overrides), kids)

def group(Event: Type, kids: List(HTML(Event)), overrides: List(Midum/Layout/Override)) -> HTML(Event):
  match stack_config(overrides):
    case document_stack_layout{flow, gap, align}:
      dom_stack(Event, flow, packed{}, gap, align, kids)

def top_left(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: top_left{}, flow: column{}, gap: none{}}, body)

def top(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: top{}, flow: column{}, gap: none{}}, body)

def top_right(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: top_right{}, flow: column{}, gap: none{}}, body)

def left(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: left{}, flow: column{}, gap: none{}}, body)

def center(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: center{}, flow: column{}, gap: none{}}, body)

def right(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: right{}, flow: column{}, gap: none{}}, body)

def bottom_left(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: bottom_left{}, flow: column{}, gap: none{}}, body)

def bottom(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: bottom{}, flow: column{}, gap: none{}}, body)

def bottom_right(Event: Type, body: HTML(Event)) -> HTML(Event):
  dom_box(Event, layout{position: bottom_right{}, flow: column{}, gap: none{}}, body)

def column(Event: Type, kids: List(HTML(Event))) -> HTML(Event):
  dom_stack(Event, column{}, packed{}, md{}, align_center_value{}, kids)

def column_between(Event: Type, kids: List(HTML(Event))) -> HTML(Event):
  dom_stack(Event, column{}, between{}, md{}, align_center_value{}, kids)

def row(Event: Type, kids: List(HTML(Event))) -> HTML(Event):
  dom_stack(Event, row{}, packed{}, md{}, align_center_value{}, kids)

def row_between(Event: Type, kids: List(HTML(Event))) -> HTML(Event):
  dom_stack(Event, row{}, between{}, md{}, align_center_value{}, kids)
