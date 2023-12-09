class RaceRecord {
  RaceRecord(int raceTime, int bestDistance) {
    _raceTime = raceTime;
    _bestDistance = bestDistance;
  }

  @override
  String toString() => "RaceRecord(raceTime=$raceTime, bestDistance=$bestDistance)";

  int get raceTime => _raceTime;
  int get bestDistance => _bestDistance;

  int _raceTime = 0;
  int _bestDistance = 0;
}