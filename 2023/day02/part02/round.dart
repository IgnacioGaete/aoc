class Round {
  Round(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }

  int get r => this._r;
  int get g => this._g;
  int get b => this._b;

  set r(int value) { this._r = value; }
  set g(int value) { this._g = value; }
  set b(int value) { this._b = value; }

  int _r = 0;
  int _g = 0;
  int _b = 0;
}