# Internal DOM card renderer for Midum.
#
# This module maps concrete card{...} values to the current DOM renderer and
# theme tracks.

import /HTML/
import Nat/is_zero as is_zero_nat
import Nat/show as show_nat

def primary(Event: Type, body: HTML(Event), cfg: Midum/Card/Config) -> HTML(Event):
  card(Event, body, cfg, "bc-card-primary")

def secondary(Event: Type, body: HTML(Event), cfg: Midum/Card/Config) -> HTML(Event):
  card(Event, body, cfg, "bc-card-secondary")

def neutral(Event: Type, body: HTML(Event), cfg: Midum/Card/Config) -> HTML(Event):
  card(Event, body, cfg, "bc-card-neutral")

def success(Event: Type, body: HTML(Event), cfg: Midum/Card/Config) -> HTML(Event):
  card(Event, body, cfg, "bc-card-success")

def warning(Event: Type, body: HTML(Event), cfg: Midum/Card/Config) -> HTML(Event):
  card(Event, body, cfg, "bc-card-warning")

def danger(Event: Type, body: HTML(Event), cfg: Midum/Card/Config) -> HTML(Event):
  card(Event, body, cfg, "bc-card-danger")

def padding_class(padding: Midum/Card/Padding) -> String:
  match padding:
    case none{}:
      "bc-card-padding-none"
    case sm{}:
      "bc-card-padding-sm"
    case md{}:
      "bc-card-padding-md"
    case lg{}:
      "bc-card-padding-lg"

def radius_class(radius: Midum/Card/Radius) -> String:
  match radius:
    case square{}:
      "bc-card-square"
    case rounded{}:
      "bc-card-rounded"

def background_class(background: Midum/Card/Background) -> String:
  match background:
    case background_on{}:
      ""
    case background_off{}:
      "bc-card-background-none"

def border_class(border: Midum/Card/Border) -> String:
  match border:
    case border_on{}:
      ""
    case border_off{}:
      "bc-card-border-none"

def gradient_class(gradient: Midum/Card/Gradient) -> String:
  match gradient:
    case gradient_off{}:
      ""
    case gradient_on{}:
      "bc-card-gradient"

def visual_class(background: Midum/Card/Background, border: Midum/Card/Border, gradient: Midum/Card/Gradient) -> String:
  background_class(background) ++ " " ++ border_class(border) ++ " " ++ gradient_class(gradient)

def card_class(role_class: String, padding: Midum/Card/Padding, radius: Midum/Card/Radius, background: Midum/Card/Background, border: Midum/Card/Border, gradient: Midum/Card/Gradient) -> String:
  "bc-card " ++ role_class ++ " " ++ padding_class(padding) ++ " " ++ radius_class(radius) ++ " " ++ visual_class(background, border, gradient)

def body_class() -> String:
  "bc-card-body"

def css_url(src: String) -> String:
  "url(\"" ++ src ++ "\")"

def css_nat(value: Nat) -> String:
  show_nat(value)

def has_nine_slice(source_left: Nat, source_right: Nat, source_top: Nat, source_bottom: Nat) -> Bool:
  left_zero = is_zero_nat(source_left)
  has_nine_slice_0(left_zero, source_right, source_top, source_bottom)

def has_nine_slice_0(left_zero: Bool, right: Nat, top: Nat, bottom: Nat) -> Bool:
  match left_zero:
    case false{}:
      true{}
    case true{}:
      right_zero = is_zero_nat(right)
      has_nine_slice_1(right_zero, top, bottom)

def has_nine_slice_1(right_zero: Bool, top: Nat, bottom: Nat) -> Bool:
  match right_zero:
    case false{}:
      true{}
    case true{}:
      top_zero = is_zero_nat(top)
      has_nine_slice_2(top_zero, bottom)

def has_nine_slice_2(top_zero: Bool, bottom: Nat) -> Bool:
  match top_zero:
    case false{}:
      true{}
    case true{}:
      bottom_zero = is_zero_nat(bottom)
      has_nine_slice_3(bottom_zero)

def has_nine_slice_3(bottom_zero: Bool) -> Bool:
  match bottom_zero:
    case false{}:
      true{}
    case true{}:
      false{}

def render_nine_slice(
  Event: Type,
  src: String,
  source_left: Nat,
  source_right: Nat,
  source_top: Nat,
  source_bottom: Nat,
  target_left: Nat,
  target_right: Nat,
  target_top: Nat,
  target_bottom: Nat,
) -> HTML(Event):
  <canvas
    class="bc-card-surface bc-card-surface-canvas"
    data-surface-src={src}
    data-source-left={css_nat(source_left)}
    data-source-right={css_nat(source_right)}
    data-source-top={css_nat(source_top)}
    data-source-bottom={css_nat(source_bottom)}
    data-target-left={css_nat(target_left)}
    data-target-right={css_nat(target_right)}
    data-target-top={css_nat(target_top)}
    data-target-bottom={css_nat(target_bottom)}
    aria-hidden="true"
  />

def render_surface_image(
  Event: Type,
  src: String,
  source_left: Nat,
  source_right: Nat,
  source_top: Nat,
  source_bottom: Nat,
  target_left: Nat,
  target_right: Nat,
  target_top: Nat,
  target_bottom: Nat,
  has_slices: Bool,
) -> HTML(Event):
  match has_slices:
    case false{}:
      <div
        class="bc-card-surface bc-card-surface-image"
        style:background-image={css_url(src)}
      />
    case true{}:
      render_nine_slice(Event, src, source_left, source_right, source_top, source_bottom, target_left, target_right, target_top, target_bottom)

def render_surface(Event: Type, surface: Midum/Card/Surface) -> HTML(Event):
  match surface:
    case surface_off{}:
      text{""}
    case surface_image{src, source_left, source_right, source_top, source_bottom, target_left, target_right, target_top, target_bottom}:
      has_slices = has_nine_slice(source_left, source_right, source_top, source_bottom)
      render_surface_image(Event, src, source_left, source_right, source_top, source_bottom, target_left, target_right, target_top, target_bottom, has_slices)

def render_resolved(Event: Type, body: HTML(Event), role_class: String, padding: Midum/Card/Padding, radius: Midum/Card/Radius, background: Midum/Card/Background, border: Midum/Card/Border, gradient: Midum/Card/Gradient, surface: Midum/Card/Surface) -> HTML(Event):
  <div class={card_class(role_class, padding, radius, background, border, gradient)}>
    {render_surface(Event, surface)}
    <div class={body_class()}>
      {body}
    </div>
  </div>

def card(Event: Type, body: HTML(Event), cfg: Midum/Card/Config, role_class: String) -> HTML(Event):
  match cfg:
    case card{padding, radius, background, border, gradient, surface}:
      render_resolved(Event, body, role_class, padding, radius, background, border, gradient, surface)

def base_css() -> String:
  "
  .bc-card {
    box-sizing: border-box;
    display: block;
    position: relative;
    overflow: hidden;
    max-width: 100%;
    min-width: 0;
    border-style: solid;
    background-color: var(--bc-card-bg);
    color: var(--bc-card-text);
    border-color: var(--bc-card-border);
    transition:
      background-color 120ms ease,
      border-color 120ms ease,
      color 120ms ease,
      box-shadow 120ms ease;
  }

  .bc-card-body {
    position: relative;
    z-index: 1;
    min-width: 0;
  }

  .bc-card-surface {
    position: absolute;
    inset: 0;
    z-index: 0;
    pointer-events: none;
    border-radius: inherit;
  }

  .bc-card-surface-image {
    background-repeat: no-repeat;
    background-position: center;
    background-size: 100% 100%;
  }

  .bc-card-surface-canvas {
    display: block;
    width: 100%;
    height: 100%;
  }

  .bc-card-padding-none {
    padding: 0;
  }

  .bc-card-padding-sm {
    padding: 8px;
  }

  .bc-card-padding-md {
    padding: 16px;
  }

  .bc-card-padding-lg {
    padding: 24px;
  }

  .bc-card-square {
    border-radius: 0;
  }

  .bc-card-rounded {
    border-radius: 16px;
  }

  .bc-card-gradient {
    background-image: linear-gradient(180deg, var(--bc-card-gradient-from), var(--bc-card-gradient-to));
  }

  .bc-card-background-none {
    background-color: transparent;
    background-image: none;
  }

  .bc-card-border-none {
    border-width: 0;
    border-color: transparent;
    box-shadow: none;
  }
  "

def role_css() -> String:
  "
  .bc-card-primary {
    --bc-card-bg: var(--bc-primary-bg);
    --bc-card-text: var(--bc-primary-text);
    --bc-card-border: var(--bc-primary-border);
    --bc-card-gradient-from: var(--bc-primary-gradient-from);
    --bc-card-gradient-to: var(--bc-primary-gradient-to);
  }

  .bc-card-secondary {
    --bc-card-bg: var(--bc-secondary-bg);
    --bc-card-text: var(--bc-secondary-text);
    --bc-card-border: var(--bc-secondary-border);
    --bc-card-gradient-from: var(--bc-secondary-gradient-from);
    --bc-card-gradient-to: var(--bc-secondary-gradient-to);
  }

  .bc-card-neutral {
    --bc-card-bg: var(--bc-neutral-bg);
    --bc-card-text: var(--bc-neutral-text);
    --bc-card-border: var(--bc-neutral-border);
    --bc-card-gradient-from: var(--bc-neutral-gradient-from);
    --bc-card-gradient-to: var(--bc-neutral-gradient-to);
  }

  .bc-card-success {
    --bc-card-bg: var(--bc-success-bg);
    --bc-card-text: var(--bc-success-text);
    --bc-card-border: var(--bc-success-border);
    --bc-card-gradient-from: var(--bc-success-gradient-from);
    --bc-card-gradient-to: var(--bc-success-gradient-to);
  }

  .bc-card-warning {
    --bc-card-bg: var(--bc-warning-bg);
    --bc-card-text: var(--bc-warning-text);
    --bc-card-border: var(--bc-warning-border);
    --bc-card-gradient-from: var(--bc-warning-gradient-from);
    --bc-card-gradient-to: var(--bc-warning-gradient-to);
  }

  .bc-card-danger {
    --bc-card-bg: var(--bc-danger-bg);
    --bc-card-text: var(--bc-danger-text);
    --bc-card-border: var(--bc-danger-border);
    --bc-card-gradient-from: var(--bc-danger-gradient-from);
    --bc-card-gradient-to: var(--bc-danger-gradient-to);
  }
  "

def style_css() -> String:
  "
  .bc-style-flat .bc-card {
    border-width: 1px;
    box-shadow: none;
  }

  .bc-style-toon .bc-card {
    border-width: 2px;
    border-color: #000000;
    box-shadow: 0 2px 0 #000000;
  }

  .bc-style-toon .bc-card.bc-card-border-none {
    border-width: 0;
    border-color: transparent;
    box-shadow: none;
  }
  "

def css() -> String:
  base_css() ++ role_css() ++ style_css()

def surface_script_0() -> String:
  "
  (() => {
    let key = '__midumCardSurface';
    if (window[key]) return void window[key](document);
    let imageCache = new Map();
    let readNat = (value) => {
      value = Number(value || '0');
      return Number.isFinite(value) && value > 0 ? value : 0;
    };
    let fitEdges = (total, start, end) => {
      if (total <= 0) return [0, 0];
      let combined = start + end;
      if (combined <= 0 || combined <= total) return [start, end];
      let scale = total / combined;
      let fittedStart = start * scale;
      return [fittedStart, total - fittedStart];
    };
    let drawPart = (ctx, image, sx, sy, sw, sh, dx, dy, dw, dh) => {
      if (sw > 0 && sh > 0 && dw > 0 && dh > 0) {
        ctx.drawImage(image, sx, sy, sw, sh, dx, dy, dw, dh);
      }
    };
    let getImage = (src, onReady) => {
      let entry = imageCache.get(src);
      if (!entry) {
        let image = new Image();
        entry = { image, listeners: [] };
        image.decoding = 'async';
        image.onload = () => {
          let listeners = entry.listeners.slice();
          entry.listeners.length = 0;
          listeners.forEach((listener) => listener(image));
        };
        image.onerror = () => {
          entry.listeners.length = 0;
          imageCache.delete(src);
        };
        image.src = src;
        imageCache.set(src, entry);
      }
      if (entry.image.complete && entry.image.naturalWidth > 0 && entry.image.naturalHeight > 0) {
        return onReady(entry.image);
      }
      entry.listeners.push(onReady);
    };
  "

def surface_script_1() -> String:
  "
    let renderCanvas = (canvas, image) => {
      let rect = canvas.getBoundingClientRect();
      if (rect.width <= 0 || rect.height <= 0) return;
      let cssWidth = Math.max(1, Math.round(rect.width));
      let cssHeight = Math.max(1, Math.round(rect.height));
      let dpr = window.devicePixelRatio || 1;
      let bitmapWidth = Math.max(1, Math.round(cssWidth * dpr));
      let bitmapHeight = Math.max(1, Math.round(cssHeight * dpr));
      if (canvas.width !== bitmapWidth) canvas.width = bitmapWidth;
      if (canvas.height !== bitmapHeight) canvas.height = bitmapHeight;
      let ctx = canvas.getContext('2d');
      if (!ctx) return;
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
      ctx.clearRect(0, 0, cssWidth, cssHeight);
      let sourceLeft = readNat(canvas.dataset.sourceLeft);
      let sourceRight = readNat(canvas.dataset.sourceRight);
      let sourceTop = readNat(canvas.dataset.sourceTop);
      let sourceBottom = readNat(canvas.dataset.sourceBottom);
      let targetLeft = readNat(canvas.dataset.targetLeft);
      let targetRight = readNat(canvas.dataset.targetRight);
      let targetTop = readNat(canvas.dataset.targetTop);
      let targetBottom = readNat(canvas.dataset.targetBottom);
      let [srcLeft, srcRight] = fitEdges(image.naturalWidth, sourceLeft, sourceRight);
      let [srcTop, srcBottom] = fitEdges(image.naturalHeight, sourceTop, sourceBottom);
      let [dstLeft, dstRight] = fitEdges(cssWidth, targetLeft, targetRight);
      let [dstTop, dstBottom] = fitEdges(cssHeight, targetTop, targetBottom);
      let srcCenterWidth = Math.max(image.naturalWidth - srcLeft - srcRight, 0);
      let srcCenterHeight = Math.max(image.naturalHeight - srcTop - srcBottom, 0);
      let dstCenterWidth = Math.max(cssWidth - dstLeft - dstRight, 0);
      let dstCenterHeight = Math.max(cssHeight - dstTop - dstBottom, 0);
      let srcRightX = image.naturalWidth - srcRight;
      let srcBottomY = image.naturalHeight - srcBottom;
      let dstRightX = cssWidth - dstRight;
      let dstBottomY = cssHeight - dstBottom;
      drawPart(ctx, image, 0, 0, srcLeft, srcTop, 0, 0, dstLeft, dstTop);
      drawPart(ctx, image, srcLeft, 0, srcCenterWidth, srcTop, dstLeft, 0, dstCenterWidth, dstTop);
      drawPart(ctx, image, srcRightX, 0, srcRight, srcTop, dstRightX, 0, dstRight, dstTop);
      drawPart(ctx, image, 0, srcTop, srcLeft, srcCenterHeight, 0, dstTop, dstLeft, dstCenterHeight);
      drawPart(ctx, image, srcLeft, srcTop, srcCenterWidth, srcCenterHeight, dstLeft, dstTop, dstCenterWidth, dstCenterHeight);
      drawPart(ctx, image, srcRightX, srcTop, srcRight, srcCenterHeight, dstRightX, dstTop, dstRight, dstCenterHeight);
      drawPart(ctx, image, 0, srcBottomY, srcLeft, srcBottom, 0, dstBottomY, dstLeft, dstBottom);
      drawPart(ctx, image, srcLeft, srcBottomY, srcCenterWidth, srcBottom, dstLeft, dstBottomY, dstCenterWidth, dstBottom);
      drawPart(ctx, image, srcRightX, srcBottomY, srcRight, srcBottom, dstRightX, dstBottomY, dstRight, dstBottom);
    };
  "

def surface_script_2() -> String:
  "
    let refresh = (canvas) => {
      if (!(canvas instanceof HTMLCanvasElement)) return;
      let src = canvas.dataset.surfaceSrc || '';
      if (src === '') return;
      getImage(src, (image) => {
        if (canvas.dataset.surfaceSrc === src) renderCanvas(canvas, image);
      });
    };
    let resizeObserver =
      typeof ResizeObserver === 'function'
        ? new ResizeObserver((entries) => entries.forEach((entry) => refresh(entry.target)))
        : null;
    let bind = (canvas) => {
      if (!(canvas instanceof HTMLCanvasElement)) return;
      if (canvas.dataset.midumSurfaceBound !== '1') {
        canvas.dataset.midumSurfaceBound = '1';
        if (resizeObserver) resizeObserver.observe(canvas);
      }
      refresh(canvas);
    };
    let scan = (root) => {
      if (root instanceof HTMLCanvasElement && root.matches('.bc-card-surface-canvas')) bind(root);
      if (!root || typeof root.querySelectorAll !== 'function') return;
      root.querySelectorAll('.bc-card-surface-canvas').forEach(bind);
    };
  "

def surface_script_3() -> String:
  "
    if (typeof MutationObserver === 'function' && document.documentElement) {
      new MutationObserver((records) => {
        records.forEach((record) => {
          if (record.type === 'attributes') return bind(record.target);
          record.addedNodes.forEach(scan);
        });
      }).observe(document.documentElement, {
        childList: true,
        subtree: true,
        attributes: true,
        attributeFilter: [
          'data-surface-src',
          'data-source-left',
          'data-source-right',
          'data-source-top',
          'data-source-bottom',
          'data-target-left',
          'data-target-right',
          'data-target-top',
          'data-target-bottom',
        ],
      });
    }
    window.addEventListener('resize', () => scan(document));
    window[key] = scan;
    scan(document);
  })();
  "
