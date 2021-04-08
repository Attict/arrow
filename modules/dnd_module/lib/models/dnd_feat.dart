part of dnd_module;

class DndFeat implements CoreModel {
  static const int typeSelect = 1;
  static const int typeBackground = 2;
  static const int typeClass = 3;
  static const int typeRace = 4;

  static Map<int, String> getTypeValues() => {
    typeSelect: 'Selectable',
    typeBackground: 'Background',
    typeClass: 'Class',
    typeRace: 'Race',
  };

  int id;
  String name;
  String desc;
  int type;
  int level;
  List<DndModifier> mods;

  DndFeat({
    this.id,
    this.name,
    this.desc,
    this.type,
    this.level,
    this.mods,
  }) {
    if (this.mods == null) this.mods = List<DndModifier>();
  }

  factory DndFeat.fromMap(Map<String, dynamic> data) => DndFeat(
    id: data['id'],
    name: data['name'],
    desc: data['desc'],
    type: data['type'],
    level: data['level'],
    mods: DndModifier.createList(data['mods']),
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'desc': desc,
    'type': type,
    'level': level,
    'mods': mods?.map((i) => i.toMap()).toList(),
  };
}
