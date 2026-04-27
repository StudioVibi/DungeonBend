# DungeonBend

## Character Unlock Transition

The character select screen now treats locked heroes as inspect-only.

- Locked heroes can be previewed in the roster.
- The screen routes players toward boosters through a dedicated CTA.
- There is no direct gold purchase or local unlock action in character select anymore.

## Current Limitation

Hero unlocks are intended to come from boosters, but the current booster implementation still does not resolve hero-specific unlocks end to end.

- Opening boosters can add cards to the collection flow.
- The project still needs a follow-up implementation that converts hero-related booster rewards into actual hero unlock state.

Until that follow-up lands, the UI reflects the intended direction without claiming that boosters already complete the full hero unlock loop.
