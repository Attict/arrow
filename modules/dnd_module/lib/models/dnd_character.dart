part of dnd_module;

class DndCharacter implements CoreModel {
  int id;
  int userId;
  int campaignId;
  String portrait;
  bool public;
  String name;
  String player;
  int level;
  String alignment;
  int strength, dexterity, constitution, intelligence, wisdom, charisma;

  // Move to IDs instead of objects?
  int raceId, backgroundId, classId, archetypeId;
  List<int> skillIds, itemIds, weaponIds, armorIds, featIds;
  List<DndModifier> mods;

  String personalityTraits, ideals, bonds, flaws;
  String organizations, allies, enemies, backstory, appearance;

  int age;
  String height, weight, eyes, skin, hair;
  DndRace race;
  DndBackground background;
  DndClass baseClass;
  List<DndBonus> bonuses;

  /// These are currently equipped.  Only one armor/shield can be equipped.
  List<int> equipmentWeapons;
  int equipmentArmor;
  int equipmentShield;

  DndCharacter({
    this.id,
    this.userId,
    this.campaignId,
    this.portrait,
    this.public,
    this.name,
    this.player,
    this.level,
    this.alignment,
    this.strength,
    this.dexterity,
    this.constitution,
    this.intelligence,
    this.wisdom,
    this.charisma,
    this.raceId,
    this.backgroundId,
    this.classId,
    this.archetypeId,
    this.skillIds,
    this.personalityTraits,
    this.ideals,
    this.bonds,
    this.flaws,
    this.organizations,
    this.allies,
    this.enemies,
    this.backstory,
    this.appearance,
    this.age,
    this.height,
    this.weight,
    this.eyes,
    this.skin,
    this.hair,
    this.race,
    this.background,
    this.baseClass,
    this.bonuses,
    this.itemIds,
    this.weaponIds,
    this.armorIds,
    this.featIds,
    this.mods,
    this.equipmentWeapons,
    this.equipmentArmor,
    this.equipmentShield,
  }) {
    if (itemIds == null) itemIds = List<int>();
    if (weaponIds == null) weaponIds = List<int>();
    if (armorIds == null) armorIds = List<int>();
    if (equipmentWeapons == null) equipmentWeapons = List<int>();
  }

  factory DndCharacter.fromMap(Map<String, dynamic> data) => DndCharacter(
    id: data['id'],
    userId: data['userId'],
    campaignId: data['campaignId'],
    portrait: data['portrait'],
    public: data['public'],
    name: data['name'],
    player: data['player'],
    level: data['level'],
    alignment: data['alignment'],
    strength: data['str'],
    dexterity: data['dex'],
    constitution: data['con'],
    intelligence: data['int'],
    wisdom: data['wis'],
    charisma: data['cha'],
    raceId: data['raceId'],
    backgroundId: data['backgroundId'],
    classId: data['classId'],
    archetypeId: data['archetypeId'],
    skillIds: data['skillIds'] != null
        ? List<int>.from(data['skillIds']) : null,
    personalityTraits: data['personalityTraits'],
    ideals: data['ideals'],
    bonds: data['bonds'],
    flaws: data['flaws'],
    organizations: data['organizations'],
    allies: data['allies'],
    enemies: data['enemies'],
    backstory: data['backstory'],
    appearance: data['appearance'],
    age: data['age'],
    height: data['height'],
    weight: data['weight'],
    eyes: data['eyes'],
    skin: data['skin'],
    hair: data['hair'],
    bonuses: _mapBonuses(data['bonus']),
    itemIds: data['itemIds'] != null ? List<int>.from(data['itemIds']) : null,
    weaponIds: data['weaponIds'] != null ? List<int>.from(data['weaponIds']) : null,
    armorIds: data['armorIds'] != null ? List<int>.from(data['armorIds']) : null,
    featIds: data['featIds'] != null ? List<int>.from(data['featIds']) : null,
    mods: DndModifier.createList(data['mods']),
    equipmentWeapons: data['equipmentWeapons'] != null
        ? List<int>.from(data['equipmentWeapons']) : null,
    equipmentArmor: data['equipmentArmor'],
    equipmentShield: data['equipmentShield'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'campaignId': campaignId,
    'portrait': portrait,
    'public': public,
    'name': name,
    'player': player,
    'level': level,
    'alignment': alignment,
    'str': strength,
    'dex': dexterity,
    'con': constitution,
    'int': intelligence,
    'wis': wisdom,
    'cha': charisma,
    'raceId': raceId,
    'backgroundId': backgroundId,
    'classId': classId,
    'archetypeId': archetypeId,
    'skillIds': skillIds,
    'personalityTraits': personalityTraits,
    'ideals': ideals,
    'bonds': bonds,
    'flaws': flaws,
    'organizations': organizations,
    'allies': allies,
    'enemies': enemies,
    'backstory': backstory,
    'appearance': appearance,
    'age': age,
    'height': height,
    'weight': weight,
    'eyes': eyes,
    'skin': skin,
    'hair': hair,
    'race': race?.toMap(),
    'background': background?.toMap(),
    'class': baseClass?.toMap(),
    'bonuses': bonuses != null ? bonuses.map((i) => i.toMap()).toList() : null,
    'itemIds': itemIds,
    'weaponIds': weaponIds,
    'armorIds': armorIds,
    'featIds': featIds,
    'mods': mods != null ? mods.map((i) => i.toMap()).toList() : null,
    'equipmentWeapons': equipmentWeapons,
    'equipmentArmor': equipmentArmor,
    'equipmentShield': equipmentShield,
  };

  static List<DndBonus> _mapBonuses(List<dynamic> data) {
    if (data == null) return null;
    return data.map<DndBonus>((i) => DndBonus.fromMap(i)).toList();
  }

  int get prof {
    if (level > 16) {
      return 6;
    } else if (level > 12) {
      return 5;
    } else if (level > 8) {
      return 4;
    } else if (level > 4) {
      return 3;
    }
    return 2;
  }

}
