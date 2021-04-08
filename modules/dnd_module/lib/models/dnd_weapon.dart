part of dnd_module;

class DndWeapon implements CoreModel {
  static const typeLightMelee = 1;
  static const typeLightRanged = 2;
  static const typeMartialMelee = 3;
  static const typeMartialRanged = 4;

  static Map<int, String> getTypeValues() => {
    typeLightMelee: 'Light Melee',
    typeLightRanged: 'Light Ranged',
    typeMartialMelee: 'Martial Melee',
    typeMartialRanged: 'Martial Ranged',
  };


  static const damageBludgeoning = 1;
  static const damagePiercing = 2;
  static const damageSlashing = 3;

  static Map<int, String> getDamageValues() => {
    damageBludgeoning: 'Bludgeoning',
    damagePiercing: 'Piercing',
    damageSlashing: 'Slashing',
  };

  int id;
  DndItem item;
  int type;
  int minDmg;
  int maxDmg;
  int dmgType;
  int modType;
  int minRange;
  int maxRange;
  int profId;
  String properties;

  DndWeapon({
    this.id,
    this.item,
    this.type,
    this.minDmg,
    this.maxDmg,
    this.dmgType,
    this.modType,
    this.minRange,
    this.maxRange,
    this.profId,
    this.properties,
  }) {
    if (item == null) item = DndItem(type: DndItem.typeWeapon);
  }

  factory DndWeapon.fromMap(Map<String, dynamic> data) => DndWeapon(
    id: data['id'],
    item: data['item'] != null ? DndItem.fromMap(data['item']) : null,
    type: data['type'],
    minDmg: data['minDmg'],
    maxDmg: data['maxDmg'],
    dmgType: data['dmgType'],
    modType: data['modType'],
    minRange: data['minRange'],
    maxRange: data['maxRange'],
    profId: data['profId'],
    properties: data['properties'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'item': item?.toMap(),
    'type': type,
    'minDmg': minDmg,
    'maxDmg': maxDmg,
    'dmgType': dmgType,
    'modType': modType,
    'minRange': minRange,
    'maxRange': maxRange,
    'profId': profId,
    'properties': properties,
  };
}
