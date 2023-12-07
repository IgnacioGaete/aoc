import 'idconvertionrange.dart';

class AlmanacMap {
  static const Map<String, int> _resMap = {"seed": 0, "soil": 1, "fertilizer": 2, "water": 3, "light": 4, "temperature": 5, "humidity": 6, "location": 7};
  
  AlmanacMap(Iterable<String> data) {
    for (var line in data) {
      if (line.endsWith("map:")) {
        _name = line.split(" ").first;
      } else {
        _addIdRange(line);
      }
    }
  }

  int mapId(int id) {
    for (IdConvertionRange idRange in _idRanges) {
      int resultId = idRange.mapId(id);
      if (resultId >= 0) {
        return resultId;
      }
    }
    return id;
  }

  void _addIdRange(String line) {
    List<int> tempParse = line.split(" ").map((e) => int.parse(e)).toList();
    int outStart = tempParse.removeAt(0);
    int inStart = tempParse.removeAt(0);
    int rangeLenght = tempParse.removeAt(0);
    _idRanges.add(IdConvertionRange(inStart, outStart, rangeLenght));
  }

  @override
  bool operator==(Object o) => _name == (o as AlmanacMap).name;

  @override
  int get hashCode => _resMap[inMapName]!;

  String get name => _name;
  String get inMapName => _name.split("-to-").first;
  String get outMapName => _name.split("-to-").last;

  String _name = "";
  final List<IdConvertionRange> _idRanges = [];
}