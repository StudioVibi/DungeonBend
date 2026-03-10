import /bend/types as Types
import /bend/run as RunCore

def start_run(config: Types.Config, meta: Types.Meta, seed: U32) -> Types.Run:
  RunCore.start_run(config, meta, seed)

def upgrade_hero(config: Types.Config, meta: Types.Meta) -> Types.Meta:
  RunCore.upgrade_hero(config, meta)

def apply_swipe(config: Types.Config, meta: Types.Meta, run: Types.Run, dir: U32) -> Types.SwipeResult:
  RunCore.apply_swipe(config, meta, run, dir)
