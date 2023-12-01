import 'dart:io';

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input text>");
    exit(1);
  }
  int sum = 0;
  for (String line in File(args.first).readAsLinesSync()) {
    int calibrationNumber = getCalibrationNumber(line);
    sum += calibrationNumber;
  }
  print("Sum of all calibration numbers: $sum");
}

int getCalibrationNumber(String line) {
  List<int> digits = [];
  for (var i = 0; i < line.length; i++) {
    if (isDigit(line[i])) {
      digits.add(int.parse(line[i]));
    }
  }
  if (digits.length == 1) {
    digits.add(digits.first);
  }
  return 10 * digits.first + digits.last;
}

bool isDigit(String c) {
  return "0123456789".contains(c);
}