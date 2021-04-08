part of dnd_module;

class DndRace {
  int id;
  String name, desc;
  int speed;
  int strength, dexterity, constitution, intelligence, wisdom, charisma;
  int attrPoints, featPoints, langPoints;
  List<int> proficiencyIds;
  List<DndFeat> feats;

  DndRace({
    this.id,
    this.name,
    this.desc,
    this.speed,
    this.strength,
    this.dexterity,
    this.constitution,
    this.intelligence,
    this.wisdom,
    this.charisma,
    this.attrPoints,
    this.featPoints,
    this.langPoints,
    this.proficiencyIds,
    this.feats,
  }) {
    if (proficiencyIds == null) proficiencyIds = List<int>();
    if (feats == null) feats = List<DndFeat>();
  }

  factory DndRace.fromMap(Map<String, dynamic> data) => DndRace(
    id: data['id'],
    name: data['name'],
    desc: data['desc'],
    speed: data['speed'],
    strength: data['str'],
    dexterity: data['dex'],
    constitution: data['con'],
    intelligence: data['int'],
    wisdom: data['wis'],
    charisma: data['cha'],
    attrPoints: data['attrPoints'],
    featPoints: data['featPoints'],
    langPoints: data['langPoints'],
    proficiencyIds: data['proficiencyIds'] != null
        ? List<int>.from(data['proficiencyIds']) : List<int>(),
    feats: data['feats'] != null ? data['feats'].map<DndFeat>(
        (i) => DndFeat.fromMap(i)).toList() : null,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'desc': desc,
    'speed': speed,
    'str': strength,
    'dex': dexterity,
    'con': constitution,
    'int': intelligence,
    'wis': wisdom,
    'cha': charisma,
    'attrPoints': attrPoints,
    'featPoints': featPoints,
    'langPoints': langPoints,
    'proficiencyIds': proficiencyIds,
    'feats': feats != null ? feats.map((i) => i.toMap()).toList() : null,
  };

  bool hasAttr() => strength > 0 || dexterity > 0 || constitution > 0
      || intelligence > 0 || wisdom > 0 || charisma > 0;
}
