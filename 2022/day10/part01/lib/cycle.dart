class Cycle {
  Cycle(int startValue, int execValue, int endValue) {
    this._startValue = startValue;
    this._execValue = execValue;
    this._endValue = endValue;
  }

  int get startValue => this._startValue;
  int get execValue => this._execValue;
  int get endValue => this._endValue;

  int _startValue  = 0;
  int _execValue  = 0;
  int _endValue  = 0;
}