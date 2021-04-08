part of dnd_module;

class DndBonus {
  static const int typeStr          = 1;
  static const int typeDex          = 2;
  static const int typeCon          = 3;
  static const int typeInt          = 4;
  static const int typeWis          = 5;
  static const int typeCha          = 6;
  static const int typeSpeed        = 7;
  static const int typeAC           = 8;
  static const int typeInit         = 9;
  static const int typeFeat         = 10;

  static const int fromRace         = 1;
  static const int fromClass        = 2;
  static const int fromBackground   = 3;

  static Map<int, String> typeValues() => {
    typeStr:              'STR',
    typeDex:              'DEX',
    typeCon:              'CON',
    typeInt:              'INT',
    typeWis:              'WIS',
    typeCha:              'CHA',
    typeSpeed:            'Speed',
    typeAC:               'AC',
    typeInit:             'Init',
    typeFeat:             'Feat',
  };

  static Map<int, String> fromValues() => {
    fromRace:             'Race',
    fromClass:            'Class',
    fromBackground:       'Background',
  };

  int id, type, value, from;
  String desc;

  DndBonus({
    this.id,
    this.type,
    this.value,
    this.from,
    this.desc,
  });

  factory DndBonus.fromMap(Map<String, dynamic> data) => DndBonus(
    id: data['id'],
    type: data['type'],
    value: data['value'],
    from: data['from'],
    desc: data['desc'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type,
    'value': value,
    'from': from,
    'desc': desc,
  };
}
