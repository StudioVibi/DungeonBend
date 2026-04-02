import /App/
import /Dungeon/DungeonState as DungeonState
import /Dungeon/DungeonEvent as DungeonEvent
import /Dungeon/App/init as init
import /Dungeon/App/on_event as on_event
import /Dungeon/View/render as render

main : App =
  app{DungeonState, DungeonEvent, init, render, on_event, none{}}
