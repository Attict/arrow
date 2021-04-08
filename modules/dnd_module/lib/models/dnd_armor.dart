part of dnd_module;

class DndArmor implements CoreModel {
  static const typeNone = 0;
  static const typeLight = 1;
  static const typeMedium = 2;
  static const typeHeavy = 3;

  static Map<int, String> getTypeValues() => {
    typeNone: 'None',
    typeLight: 'Light',
    typeMedium: 'Medium',
    typeHeavy: 'Heavy',
  };

  static const slotArmor = 1;
  static const slotShield = 2;

  static Map<int,String> getSlotValues() => {
    slotArmor: 'Armor',
    slotShield: 'Shield',
  };

  int id;
  DndItem item;

  ///
  /// type
  ///
  ///
  int type;

  ///
  /// slot
  ///
  /// Which armor slot this goes in, such as helm, shield, etc.
  ///
  int slot;

  ///
  /// ac
  ///
  /// Raw armor class - without dexterity mod, etc.
  ///
  int ac;

  ///
  /// reqStr
  ///
  /// Required Strength to use armor.
  ///
  int reqStr;

  ///
  /// dexMod
  ///
  bool dexMod;

  ///
  /// dexModMax
  ///
  /// Maximum dexterity modifier
  ///
  int dexModMax;

  ///
  /// daStealth
  ///
  /// Disadvantage Stealth
  ///
  bool daStealth;

  ///
  /// profId
  ///
  /// Required proficiency ID to avoid negative modfiiers.
  ///
  int profId;

  ///
  /// DndArmor
  ///
  ///
  DndArmor({
    this.id,
    this.item,
    this.type,
    this.slot,
    this.ac,
    this.reqStr,
    this.dexMod,
    this.dexModMax,
    this.daStealth,
    this.profId,
  }) {
    if (item == null) item = DndItem(type: DndItem.typeArmor);
  }

  ///
  /// DndArmor.fromMap
  ///
  factory DndArmor.fromMap(Map<String, dynamic> data) => DndArmor(
    id: data['id'],
    item: data['item'] != null ? DndItem.fromMap(data['item']) : null,
    type: data['type'],
    slot: data['slot'],
    ac: data['ac'],
    reqStr: data['reqStr'],
    dexMod: data['dexMod'],
    dexModMax: data['dexModMax'],
    daStealth: data['daStealth'],
    profId: data['profId'],
  );

  ///
  /// toMap
  ///
  ///
  Map<String, dynamic> toMap() => {
    'id': id,
    'item': item?.toMap(),
    'type': type,
    'slot': slot,
    'ac': ac,
    'reqStr': reqStr,
    'dexMod': dexMod,
    'dexModMax': dexModMax,
    'daStealth': daStealth,
    'profId': profId,
  };
}
