import 'dart:io';

enum HandType {
  HIGH_CARD,
  ONE_PAIR,
  TWO_PAIR,
  THREE_OF_A_KIND,
  FULL_HOUSE,
  FOUR_OF_A_KIND,
  FIVE_OF_A_KIND
}

class Hand {
  static const int _base = 13;//13 symbols
  Hand (String cards, int bid) {
    _cards = cards;
    _bid = bid;
    _handType = _getHandType(cards);
  }

  int getTotalStrength() {
    int totalStrength = 0;
    int b = 1;
    for (var i = 0; i < _cards.length; i++) {
      totalStrength += _cardRelativeStrength(_cards[_cards.length - i - 1]) * b;
      b *= _base;
    }
    return totalStrength + _getTypeRelativeStrength() * b;
  
  }

  int _cardRelativeStrength(String card) => switch(card) {
    "2" => 0,
    "3" => 1,
    "4" => 2,
    "5" => 3,
    "6" => 4,
    "7" => 5,
    "8" => 6,
    "9" => 7,
    "T" => 8,
    "J" => 9,
    "Q" => 10,
    "K" => 11,
    "A" => 12,
    _ => exit(1)
  };

  int _getTypeRelativeStrength() => _handType.index;

  HandType _getHandType(String cards) {
    /**
     * 12345 -> HIGH_CARD
     * 12343 -> ONE_PAIR
     */
    int singles = _getSinglesCount(cards);
    if (singles == 5) {
      return HandType.HIGH_CARD;
    }
    if (singles == 4) {
      return HandType.ONE_PAIR;
    }
    int pairs = _getPairsCount(cards);
    if (singles == 3) {
      /**
       * 12322 -> THREE_OF_A_KIND
       * 12321 -> TWO_PAIR
       */
      if (pairs == 0) {
        return HandType.THREE_OF_A_KIND;
      }
      if (pairs == 2) {
        return HandType.TWO_PAIR;
      }
    }
    if (singles == 2) {
      /**
       * 12222 -> FOUR_OF_A_KIND
       * 12221 -> FULL_HOUSE
       */
      if (pairs == 0) {
        return HandType.FOUR_OF_A_KIND;
      }
      if (pairs == 1) {
        return HandType.FULL_HOUSE;
      }
    }
    /**
     * 11111 -> FIVE_OF_A_KIND
     */
    return HandType.FIVE_OF_A_KIND;
  }

  int _getSinglesCount(String cards) {
    int singlesCount = 0;
    List<String> symbols = cards.split("");
    while (symbols.length > 0) {
      String symbol = symbols.removeAt(0);
      symbols.removeWhere((element) => element == symbol);
      singlesCount++;
    }
    return singlesCount;
  }

  int _getPairsCount(String cards) {
    int pairsCount = 0;
    List<String> symbols = cards.split("");
    while (symbols.length > 0) {
      String symbol = symbols.removeAt(0);
      if (!symbols.contains(symbol)) {
        continue;
      }
      symbols.remove(symbol);
      if (symbols.contains(symbol)) {
        while (symbols.contains(symbol)) {
          symbols.remove(symbol);
        }
        continue;
      }
      pairsCount++;
    }
    return pairsCount;
  }

  @override
  String toString() => "Hand(card='$_cards', bid=$_bid, handType=$_handType)";

  int get bid => _bid;

  String _cards = "";
  int _bid = 0;
  HandType _handType = HandType.HIGH_CARD;
}