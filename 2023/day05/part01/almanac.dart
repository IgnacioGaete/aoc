import 'dart:io';

import 'almanacmap.dart';

class Almanac {
  Almanac(String filePath) {
    List<String> lines = File(filePath).readAsLinesSync();
    _loadSeeds(lines);
    _loadMaps(lines);
  }

  int mapId(String inMapName, String outMapName, int id) {
    int resultId = id;
    String nextInMapName = inMapName;
    while (nextInMapName != outMapName) {
      AlmanacMap map = _maps.singleWhere((e) => e.inMapName == nextInMapName);
      resultId = map.mapId(resultId);
      nextInMapName = map.outMapName;
    }
    return resultId;
  }

  void _loadSeeds(List<String> lines) {
    _seeds.addAll(lines.first.split(": ").last.split(" ").map((e) => int.parse(e)));
  }

  void _loadMaps(List<String> inputLines) {
    List<String> lines = List.from(inputLines);
    while (lines.length > 0) {
      String line = lines.removeAt(0);
      if (line.endsWith("map:")) {
        List<String> data = [];
        while (lines.length > 0 && line.isNotEmpty) {
          data.add(line);
          line = lines.removeAt(0);
        }
        _addMap(data);
      }
    }
  }

  void _addMap(Iterable<String> data) => _maps.add(AlmanacMap(data));

  List<int> get seeds => List.from(_seeds);

  final List<int> _seeds = [];
  final Set<AlmanacMap> _maps = {};
}