import 'dart:io';

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input file>");
    exit(1);
  }
  int sum = 0;
  for (String line in File(args.first).readAsLinesSync()) {
    List<int> values = line.split(" ").map((e) => int.parse(e)).toList();
    sum += extrapolateValues(values);
  }
  print("Result: $sum");
}

int extrapolateValues(List<int> values) => extrapolateValuesRecurse(List.from(values).reversed.toList(), values.length);

int extrapolateValuesRecurse(List values, int lenght) {
  if (lenght == 1) {
    return values.first;
  }
  bool allEqual = true;
  for (var i = 0; i < lenght; i++) {
    if (values.first != values[i]) {
      allEqual = false;
      break;
    }
  }
  if (allEqual) {
    return values.first;
  }
  for (var i = 0; i < lenght - 1; i++) {
    values[i] = values[i] - values[i + 1];
  }
  return values[lenght - 1] - extrapolateValuesRecurse(values, lenght - 1);
}