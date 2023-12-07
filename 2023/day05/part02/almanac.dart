import 'dart:io';
import 'dart:math';

import 'almanacmap.dart';
import 'idrange.dart';

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

  int getMinLocationId() {
    int locId = -1;
    for (IdRange idRange in _seeds) {
      int rStart = idRange.rangeStart;
      int rLenght = idRange.rangeLenght;
      print("Searching in $idRange...");
      for (int seedId = rStart; seedId < rStart + rLenght; seedId++) {
        int nextLocId = mapId("seed", "location", seedId);
        // print("seed: $seedId -> location: $nextLocId");
        locId = locId < 0 ? nextLocId : min(locId, nextLocId);
      }
      print("location id found so far: $locId");
    }
    return locId;
  }

  void _loadSeeds(List<String> lines) {
    List<int> numbers = lines[0].split(": ").last.split(" ").map((e) => int.parse(e)).toList();
    while (numbers.length > 1) {
      int rangeStart = numbers.removeAt(0);
      int rangeLen = numbers.removeAt(0);
      _seeds.add(IdRange(rangeStart, rangeLen));
    }
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

  final List<IdRange> _seeds = [];
  final Set<AlmanacMap> _maps = {};
}