import 'dart:io';
import 'dart:math';

class Knot{
  Knot(int x, int y, int lenght){
    this.pos = Point(x, y);
    if (lenght > 1) {
      this._nextKnot = Knot(x, y, lenght - 1);
    }
  }

  void followInstruction(String dir, int count){
    while (count > 0) {
      this.pos = switch (dir) {
        "R" => Point(this._pos.x + 1, this._pos.y),
        "L" => Point(this._pos.x - 1, this._pos.y),
        "U" => Point(this._pos.x, this._pos.y + 1),
        "D" => Point(this._pos.x, this._pos.y - 1),
        _ => exit(1)
      };
      this._nextKnot?.followKnot(this);
      count--;
    }
  }

  void followKnot(Knot knot) {
    if (this._pos.squaredDistanceTo(knot.pos) > 2) {
      this.pos += directionTo(knot);
    }
    this._nextKnot?.followKnot(this);
  }

  Point directionTo(Knot knot) {
    int x = this.pos.x < knot.pos.x ? 1 : this.pos.x > knot.pos.x ? -1 : 0;
    int y = this.pos.y < knot.pos.y ? 1 : this.pos.y > knot.pos.y ? -1 : 0;
    return Point(x, y);
  }

  String toString() => "(${this._pos.x},${this._pos.y})" + (this.nextKnot != null ? "->${this.nextKnot}" : "");

  Knot? get nextKnot => this._nextKnot;
  Set<Point> get visitedPoints => this._visitedPoints;
  Point get pos => this._pos;

  set pos(Point value) {
      this._pos = Point(value.x, value.y);
      this._visitedPoints.add(value);
  }

  Point _pos = Point(0, 0);
  Set<Point> _visitedPoints = Set();
  Knot? _nextKnot;
}