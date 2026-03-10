import type { Direction } from "./types";

type SwipeCleanup = () => void;

type SwipeOptions = {
  threshold?: number;
};

export function bindSwipe(
  element: HTMLElement,
  onSwipe: (direction: Direction) => void,
  options: SwipeOptions = {},
): SwipeCleanup {
  var threshold = options.threshold ?? 24;
  var pointerId = -1;
  var startX = 0;
  var startY = 0;

  function reset(): void {
    pointerId = -1;
  }

  function onPointerDown(event: PointerEvent): void {
    pointerId = event.pointerId;
    startX = event.clientX;
    startY = event.clientY;
  }

  function onPointerUp(event: PointerEvent): void {
    if (event.pointerId !== pointerId) {
      return;
    }

    var deltaX = event.clientX - startX;
    var deltaY = event.clientY - startY;
    reset();

    if (Math.abs(deltaX) < threshold && Math.abs(deltaY) < threshold) {
      return;
    }

    if (Math.abs(deltaX) > Math.abs(deltaY)) {
      onSwipe(deltaX > 0 ? "right" : "left");
      return;
    }

    onSwipe(deltaY > 0 ? "down" : "up");
  }

  function onPointerCancel(): void {
    reset();
  }

  element.addEventListener("pointerdown", onPointerDown);
  element.addEventListener("pointerup", onPointerUp);
  element.addEventListener("pointercancel", onPointerCancel);
  element.addEventListener("pointerleave", onPointerCancel);

  return () => {
    element.removeEventListener("pointerdown", onPointerDown);
    element.removeEventListener("pointerup", onPointerUp);
    element.removeEventListener("pointercancel", onPointerCancel);
    element.removeEventListener("pointerleave", onPointerCancel);
  };
}
