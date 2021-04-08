part of dnd_module;

class DndModifier {
  ///
  /// Specific Modifier Types
  ///
  static const int typeAttr = 1;
  static const int typeSkill = 2;
  static const int typeSpell = 3; // Spell count only?

  ///
  /// General Modifier Types
  ///
  static const int typeStr = 1;
  static const int typeDex = 2;
  static const int typeCon = 3;
  static const int typeInt = 4;
  static const int typeWis = 5;
  static const int typeCha = 6;
  static const int typeHp = 7;
  static const int typeAC = 8;
  static const int typeSpeed = 9;
  static const int typeInit = 10;
  static const int typeFeat = 11;
  static const int typeHit = 12;
  static const int typeDamage = 13;
  static const int typeMinRange = 14;
  static const int typeMaxRange = 15;

  ///
  /// typeValues
  ///
  static Map<int, String> get typeValues => {
    typeAttr: 'Attribute',
    typeSkill: 'Skill',
  };

  ///
  /// subTypeValues
  ///
  /// Maybe this should be typeValues... sicne this is generalized heavily.
  ///
  static Map<int, String> get subtypeValues => {
    typeStr: 'Strength',
    typeDex: 'Dexterity',
    typeCon: 'Constitution',
    typeInt: 'Intelligence',
    typeWis: 'Wisdom',
    typeCha: 'Charisma',
    typeHp: 'Hit Points',
    typeAC: 'Armor Class',
    typeSpeed: 'Speed',
    typeInit: 'Initiative',
  };

  static Map<int, String> get attrValues => {
    typeStr: 'Strength',
    typeDex: 'Dexterity',
    typeCon: 'Constitution',
    typeInt: 'Intelligence',
    typeWis: 'Wisdom',
    typeCha: 'Charisma',
  };

  ///
  /// createList
  ///
  /// Creates a list of modifiers from the JSON decoded data.
  ///
  static List<DndModifier> createList(List<dynamic> data) {
    if (data == null) return null;
    return data.map<DndModifier>((i) => DndModifier.fromMap(i)).toList();
  }

  int type;
  int subtype; // type or skillId
  int value;

  DndModifier({
    this.type,
    this.subtype,
    this.value,
  });

  factory DndModifier.fromMap(Map<String, dynamic> data) => DndModifier(
    type: data['type'],
    subtype: data['subtype'],
    value: data['value'],
  );

  Map<String, dynamic> toMap() => {
    'type': type,
    'subtype': subtype,
    'value': value,
  };
}
