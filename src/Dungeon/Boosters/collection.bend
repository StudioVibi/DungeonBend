import Dungeon/CardRef as CardRef
import Dungeon/DeckEntry as DeckEntry
import Dungeon/PackReward as PackReward
import Dungeon/Deck/counts_pick/card_ref_entry as card_ref_entry
import Dungeon/Deck/counts_pick/add_deck_entry as add_deck_entry

def bonus_deck_after_reward(bonus_deck: List(DeckEntry), reward: PackReward) -> List(DeckEntry):
  match reward:
    case no_pack_reward{}:
      bonus_deck
    case pack_reward{cards}:
      _bonus_deck_from_cards(bonus_deck, cards)

def _bonus_deck_from_cards(bonus_deck: List(DeckEntry), cards: List(CardRef)) -> List(DeckEntry):
  match cards:
    case []:
      bonus_deck
    case card<>rest:
      _bonus_deck_from_cards(add_deck_entry(bonus_deck, card_ref_entry(card, 1)), rest)
