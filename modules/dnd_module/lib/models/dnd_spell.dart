part of dnd_module;

class DndSpell implements CoreModel {
  static const shapeLine = 1;
  static const shapeCone = 2;
  static const shapeSphere = 3;
  static Map<int, String> getShapeValues() => {
    shapeLine: 'Line',
    shapeCone: 'Cone',
    shapeSphere: 'Sphere',
  };

  static const typeFire = 1;
  static const typeLightning = 2;
  static Map<int, String> getTypeValues() => {
    typeFire: 'Fire',
    typeLightning: 'Lightning',
  };

  static const saveStr = 1;
  static const saveDex = 2;
  static const saveCon = 3;
  static const saveInt = 4;
  static const saveWis = 5;
  static const saveCha = 6;
  static  Map<int, String> getSaveValues() => {
    saveStr: 'Strength',
    saveDex: 'Dexterity',
    saveCon: 'Constitution',
    saveInt: 'Intelligence',
    saveWis: 'Wisdom',
    saveCha: 'Charisma',
  };

  int id;
  String name;
  String desc;
  int level;
  int range;
  int shape;
  int type;
  int save;

  DndSpell({
    this.id,
    this.name,
    this.desc,
    this.level,
    this.range,
    this.shape,
    this.type,
    this.save,
  });

  factory DndSpell.fromMap(Map<String, dynamic> data) => DndSpell(
    id: data['id'],
    name: data['name'],
    desc: data['desc'],
    level: data['level'],
    range: data['range'],
    shape: data['shape'],
    type: data['type'],
    save: data['save'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'desc': desc,
    'level': level,
    'range': range,
    'shape': shape,
    'type': type,
    'save': save,
  };
}
