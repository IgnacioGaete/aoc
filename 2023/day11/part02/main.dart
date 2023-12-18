import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input file>");
    exit(1);
  }
  final galaxies = loadGalaxiesAndExpandSpace(args.first);
  final distances = getMinDistances(galaxies);
  print("Result: ${distances.reduce((value, element) => value + element)}");
}


List<Point<int>> loadGalaxiesAndExpandSpace(String filePath) {
  final galaxies = <Point<int>>[];
  final lines = File(filePath).readAsLinesSync();
  final emptyRows = List.generate(lines.length, (index) => index);
  final emptyCols = List.generate(lines.first.length, (index) => index);
  for (int y = 0; y < lines.length; y++) {
    final String line = lines[y];
    for (int x = 0; x < line.length; x++) {
      if (line[x] == "#") {
        galaxies.add(Point(x, y));
        emptyCols.remove(x);
        emptyRows.remove(y);
      }
    }
  }
  const SPACE = 1000000 - 1;
  for (var i = 0; i < galaxies.length; i++) {
    int dy = emptyRows.where((element) => galaxies[i].y > element).length;
    int dx = emptyCols.where((element) => galaxies[i].x > element).length;
    var newGalaxy = Point(galaxies[i].x + dx * SPACE, galaxies[i].y + dy * SPACE);
    galaxies[i] = newGalaxy;
  }
  return galaxies;
}
List<int> getMinDistances(List<Point<int>> galaxies) {
  final distances = <int>[];
  for (var i = 0; i < galaxies.length; i++) {
    for (var j = i; j < galaxies.length; j++) {
      if (j != i) {
        var dx = galaxies[i].x - galaxies[j].x;
        var dy = galaxies[i].y - galaxies[j].y;
        distances.add(dx.abs() + dy.abs());
      }
    }
  }
  return distances;
}