class IdRange {
  IdRange(int rangeStart, int rangeLenght) {
    _rangeStart = rangeStart;
    _rangeLenght = rangeLenght;
  }

  @override
  String toString() => "IdRange(start=$rangeStart, lenght=$rangeLenght)";

  int get rangeStart => _rangeStart;
  int get rangeLenght => _rangeLenght;

  int _rangeStart = 0;
  int _rangeLenght = 0;
}