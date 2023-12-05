class Card {
  Card(int id, List<int> wNumbers, List<int> pNumbers) {
    this._id = id;
    this._wNumbers = wNumbers;
    this._pNumbers = pNumbers;
  }
  int getPoints() {
    Iterable<int> matches = this._wNumbers.where((element) => this._pNumbers.contains(element));
    int points = matches.length > 0 ? 1 << matches.length - 1 : 0;
    return points;
  }
  List<int> getNextIds() {
    List<int> nextIds = [];
    Iterable<int> matches = this._wNumbers.where((element) => this._pNumbers.contains(element));
    for (var i = 0; i < matches.length; i++) {
      nextIds.add(this.id + i+ 1);
    }
    return nextIds;
  }
  String toString() => "Card ${this.id}";
  int get id => this._id;
  int _id = -1;
  List<int> _wNumbers = [];
  List<int> _pNumbers = [];
}