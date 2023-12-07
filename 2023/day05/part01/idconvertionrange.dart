class IdConvertionRange {
  IdConvertionRange(int inStart, int outStart, int lenght) {
    _inStart = inStart;
    _outStart = outStart;
    _lenght = lenght;
  }

  int mapId(int id) => id >= _inStart && id < _inStart + _lenght ? _outStart + id - _inStart : -1;

  int _inStart = 0;
  int _outStart = 0;
  int _lenght = 0;
}