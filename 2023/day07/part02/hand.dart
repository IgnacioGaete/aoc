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
    "J" => 0,
    "2" => 1,
    "3" => 2,
    "4" => 3,
    "5" => 4,
    "6" => 5,
    "7" => 6,
    "8" => 7,
    "9" => 8,
    "T" => 9,
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
    int singles = _getSymbolsCount(cards);
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

  int _getSymbolsCount(String cards) {
    if (cards == "JJJJJ") {
      return 1;
    }
    int symbolsCount = 0;
    List<String> symbols = cards.split("");
    symbols.removeWhere((element) => element == "J");
    while (symbols.length > 0) {
      String symbol = symbols.removeAt(0);
      symbols.removeWhere((element) => element == symbol);
      symbolsCount++;
    }
    return symbolsCount;
  }

  int _getPairsCount(String cards) {
    int pairsCount = 0;
    List<String> symbols = _replaceJokers(cards).split("");
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

  String _replaceJokers(String cards) => cards.replaceAll("J", _mostCommonCard(cards));

  String _mostCommonCard(String cards) {
    if (cards == "JJJJJ") {
      return "A";
    }
    List<String> symbols = cards.split("");
    symbols.removeWhere((element) => element == "J");
    int prevCount = -1;
    String mostCommon = symbols[0];
    while (symbols.length > 0) {
      String symbol = symbols.removeAt(0);
      int count = 1 + symbols.where((element) => element == symbol).length;
      if (count > prevCount) {
        mostCommon = symbol;
        prevCount = count;
      }
    }
    return mostCommon;
  }

  @override
  String toString() => "Hand(card='$_cards', bid=$_bid, handType=$_handType)";

  int get bid => _bid;

  String _cards = "";
  int _bid = 0;
  HandType _handType = HandType.HIGH_CARD;
}