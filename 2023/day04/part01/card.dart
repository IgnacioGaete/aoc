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
  int _id = -1;
  List<int> _wNumbers = [];
  List<int> _pNumbers = [];
}