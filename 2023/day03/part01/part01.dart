import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input text>");
    exit(1);
  }
  Map<Point, Entry> map = getPointToEntryMap(args.first);
  //print(map);
  Set<Entry> partNumbers = getPartEntries(args.first, map);
  //print(partNumbers);
  int sum = partNumbers.map((e) => e.value).toList().reduce((value, element) => value + element);
  print("Result: $sum");
}

class Entry {
  Entry(int id, int value) {
    this.value = value;
    this.id = id;
  }
  String toString() => "Entry(id=${this.id}, value=${this.value})";
  bool operator==(Object other) => (other as Entry).id == this.id;
  int get hashCode => this.id;
  int value = -1;
  int id = -1;
}

Map<Point, Entry> getPointToEntryMap(String filePath) {
  Map<Point, Entry> map = Map();
  List<String> lines = File(filePath).readAsLinesSync();
  int id = 0;
  for (int y = 0; y < lines.length; y++) {
    String stringNumb = "";
    List<Point> numberSpan = [];
    for (int x = 0; x < lines[y].length; x++) {
      if (isDigit(lines[y][x])) {
        stringNumb += lines[y][x];
        numberSpan.add(Point(x, y));
      } else {
        if (stringNumb.isNotEmpty) {
          int numberValue = int.parse(stringNumb);
          for (Point key in numberSpan) {
            map[key] = Entry(id, numberValue);
          }
          stringNumb = "";
          numberSpan.clear();
          id++;
        }
      }
    }
  }
  return map;
}


Set<Entry> getPartEntries(String filePath, Map<Point, Entry> map) {
  Set<Entry> partEntries = Set();
  List<String> lines = File(filePath).readAsLinesSync();
  for (int y = 0; y < lines.length; y++) {
    for (int x = 0; x < lines[y].length; x++) {
      if (isSymbol(lines[y][x])) {
        partEntries.addAll(getNeighbors(x, y, map));
      }
    }
  }
  return partEntries;
}

Set<Entry> getNeighbors(int xs, int ys, Map<Point, Entry> map) {
  Set<Entry> neighbors = Set();
  for (int y = -1; y < 2; y++) {
    for (int x = -1; x < 2; x++) {
      Point key = Point(xs + x, ys + y);
      if (map.containsKey(key)) {
        neighbors.add(Entry(map[key]!.id, map[key]!.value));
      }
    }
  }
  return neighbors;
}

bool isDigit(String char) => "0123456789".contains(char);

bool isSymbol(String char) => char != "." && !isDigit(char);
