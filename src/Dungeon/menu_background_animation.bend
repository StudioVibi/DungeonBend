import Dungeon/menu_background_frames/frames as menu_background_frames

def clip() -> Midum/Image/Animation:
  animation{
    frames: menu_background_frames(),
    fps: 8n,
    playback: loop{},
  }
