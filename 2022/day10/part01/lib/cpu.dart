import 'dart:io';

import 'cycle.dart';

class Cpu {
  Cpu(int initValue) {
    this._initValue = initValue;
  }


  void followInstructions(String filePath) {
    for (String line in File(filePath).readAsLinesSync()) {
      String name = line.split(" ").first;
      if (name == "noop") {
        this.recordNoopInst();
      } else if (name == "addx") {
        this.recordAddInst(int.parse(line.split(" ").last));
      }
    }
  }

  void recordNoopInst() {
    int startValue = this._cycles.isEmpty ? this._initValue : this._cycles.last.endValue;
    int execValue = this._cycles.isEmpty ? this._initValue : this._cycles.last.endValue;
    int endValue = this._cycles.isEmpty ? this._initValue : this._cycles.last.endValue;
    this._cycles.add(Cycle(startValue, execValue, endValue));
  }
  
  void recordAddInst(int value) {
    int startValue = this._cycles.isEmpty ? this._initValue : this._cycles.last.endValue;
    int execValue = this._cycles.isEmpty ? this._initValue : this._cycles.last.endValue;
    int endValue = this._cycles.isEmpty ? this._initValue : this._cycles.last.endValue;
    this._cycles.add(Cycle(startValue, execValue, endValue));
    this._cycles.add(Cycle(startValue, execValue, endValue + value));
  }

  List<int> get execSignalStrength {
    List<int> signalStrength = [];
    for (var i = 0; i < this._cycles.length; i++) {
      int value = this._cycles[i].execValue;
      signalStrength.add(value * (i + 1));
    }
    return signalStrength;
  }

  int _initValue = 0;
  List<Cycle> _cycles = [];
  
}