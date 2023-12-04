import 'dart:io';

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input text>");
    exit(1);
  }
  List<int> gearRatios = getGearRatios(args.first);
  int sum = gearRatios.reduce((value, element) => value + element);
  print("Result: $sum");
}

List<int> getGearRatios(String filePath) {
  List<int> gearRatios = [];
  List<String> lines = File(filePath).readAsLinesSync();
  int height = lines.length;
  int width = lines.first.length;
  for (var ys = 0; ys < height; ys++) {
    List<String> neighborLines = [];
    if (ys > 0) {
      neighborLines.add(lines[ys - 1]);
    } else {
      neighborLines.add("");
    }
    neighborLines.add(lines[ys]);
    if (ys + 1 < height) {
      neighborLines.add(lines[ys + 1]);
    } else {
      neighborLines.add("");
    }
    for (var xs = 0; xs < width; xs++) {
      if (lines[ys][xs] == "*") {
        List<int> numbers = getNumbers(xs, neighborLines);
        if (numbers.length == 2) {
          gearRatios.add(numbers.reduce((value, element) => value * element));
        }
      }
    }
  }
  return gearRatios;
}

class ValuePoint {
  ValuePoint(int value, int x) {
    this.value = value;
    this.x = x;
    this.lenght = value.toString().length;
  }
  int value = 0;
  int x = 0;
  int lenght = 0;
}

List<int> getNumbers(int xs, List<String> neighborLines) {
  assert(neighborLines.length == 3, "[ERROR] neighborLines.lenght = ${neighborLines.length}");
  List<ValuePoint> numbers = [];
  for (String line in neighborLines) {
    String stringNumber = "";
    int xn = -1;
    for (int x = 0; x < line.length; x++) {
      if (isDigit(line[x])) {
        if (stringNumber.isEmpty) {
          xn = x;
        }
        stringNumber += line[x];
      }
      if (x + 1 == line.length || !isDigit(line[x])) {
        if (stringNumber.isNotEmpty && xn != -1) {
          numbers.add(ValuePoint(int.parse(stringNumber), xn));
          stringNumber = "";
          xn = -1;
        }
      }
    }
  }
  return numbers.where((element) => xs >= element.x - 1 && xs <= element.x + element.lenght).map((e) => e.value).toList();
}

List<int> getPartNumbers(String filePath) {
  List<int> partNumbers = [];
  List<String> lines = File(filePath).readAsLinesSync();
  for (int y = 0; y < lines.length; y++) {
    String stringNumb = "";
    for (int x = 0; x < lines[y].length; x++) {
      if (isDigit(lines[y][x])) {
        stringNumb += lines[y][x];
      }
      if (x == lines[y].length - 1 || !isDigit(lines[y][x])) {
        if (stringNumb.isNotEmpty) {
          int xn = x - stringNumb.length + (x == lines[y].length - 1 && isDigit(lines[y][x])? 1 : 0);
          int yn = y;
          List<String> neighbors = getNeighbors(xn, yn, stringNumb, filePath);
          if (neighbors.any((neighbor) => isSymbol(neighbor))) {
            partNumbers.add(int.parse(stringNumb));
          }
          stringNumb = "";
        }
      }
    }
  }
  return partNumbers;
}

List<String> getNeighbors(int xn, int yn, String stringNumb, String filePath) {
  List<String> neighbors = [];
  List<String> lines = File(filePath).readAsLinesSync();
  int height = lines.length;
  int width = lines.first.length;
  for (int y = -1; y <= 1; y++) {
    for (int x = -1; x <= stringNumb.length ; x++) {
      int ys = yn + y;
      int xs = xn + x;
      if (ys >= 0 && ys < height && xs >= 0 && xs < width) {
        if (!(ys == yn && xs >= xn && xs <= xn + stringNumb.length - 1)) {
          neighbors.add(lines[ys][xs]);
        }
      }
    }
  }
  return neighbors;
}

bool isDigit(String char) => "0123456789".contains(char);

bool isSymbol(String char) => char != "." && !isDigit(char);