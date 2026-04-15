# Layout CSS Inventory

This note tracks the boundary between game visuals and Midum layout primitives.

## Visual do jogo
- Theme/root rules in `base_css`: background, text color, font family, reset, touch behavior.
- HUD and topbar visuals: `.topbar`, `.resource-bar`, `.topbar-stat`, labels, font sizes and color tokens.
- Hero/menu visuals: `.menu-hero-panel`, portrait sizing, hero image sizing, heart HUD, upgrade labels.
- Card/board visuals and FX: `.card`, `.board-slot`, badges, impact animations, game-over presentation.
- Booster visuals: pack art, reveal card art, metadata typography and card-specific presentation.

## Layout generico que deve virar Midum por tela
- Page/shell placement: viewport height, safe-area padding, centered app width.
- Screen regions: top header, centered content and bottom actions.
- Action grouping: vertical stack, gap, stretch alignment and action slot width.
- Repeated screen scaffolds in boosters, board and game-over are candidates for later passes.

## Ponte temporaria
- Setup screen previously used `.shell--menu-midum` and `.menu-actions--midum` to steer Midum internals from app CSS.
- Those setup-specific bridge rules were removed in favor of `Layout.group(...)`.
- Remaining setup CSS should be either global shell behavior or visual styling of game-specific content.
