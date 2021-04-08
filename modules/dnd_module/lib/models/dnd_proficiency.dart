part of dnd_module;

class DndProficiency {
  static const int typeLanguage = 1;
  static const int typeWeapon = 2;
  static const int typeArmor = 3;

  static Map<int, String> getTypeValues() => {
    typeLanguage: 'Language',
    typeArmor: 'Armor',
    typeWeapon: 'Weapon',
  };

  int id;
  String name;
  String desc;
  int type;
  List<DndModifier> mods;

  DndProficiency({
    this.id,
    this.name,
    this.desc,
    this.type,
    this.mods,
  }) {
    if (this.mods == null) this.mods = List<DndModifier>();
  }

  factory DndProficiency.fromMap(Map<String, dynamic> data) => DndProficiency(
    id: data['id'],
    name: data['name'],
    desc: data['desc'],
    type: data['type'],
    mods: DndModifier.createList(data['mods']),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'desc': desc,
    'type': type,
    'mods': mods?.map((i) => i.toMap()).toList(),
  };
}
