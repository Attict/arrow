part of dnd_module;

class DndClass {
  int id;
  String name, desc;
  int hp;
  bool saveStr, saveDex, saveCon, saveInt, saveWis, saveCha;
  int numOfSkills;
  List<DndSkill> skills;
  List<int> skillIds, proficiencyIds;
  List<DndFeat> feats;

  DndClass({
    this.id,
    this.name,
    this.desc,
    this.hp,
    this.saveStr,
    this.saveDex,
    this.saveCon,
    this.saveInt,
    this.saveWis,
    this.saveCha,
    this.numOfSkills,
    this.skills,
    this.skillIds,
    this.proficiencyIds,
    this.feats,
  }) {
    if (proficiencyIds == null) proficiencyIds = List<int>();
    if (feats == null) feats = List<DndFeat>();
  }

  factory DndClass.fromMap(Map<String, dynamic> data) => DndClass(
    id: data['id'],
    name: data['name'],
    desc: data['desc'],
    hp: data['hp'],
    saveStr: data['saveStr'],
    saveDex: data['saveDex'],
    saveCon: data['saveCon'],
    saveInt: data['saveInt'],
    saveWis: data['saveWis'],
    saveCha: data['saveCha'],
    numOfSkills: data['numOfSkills'],
    skillIds: data['skillIds'] != null
        ? List<int>.from(data['skillIds']) : null,
    proficiencyIds: data['proficiencyIds'] != null
        ? List<int>.from(data['proficiencyIds']) : null,
    feats: data['feats'] != null ? data['feats'].map<DndFeat>(
        (i) => DndFeat.fromMap(i)).toList() : null,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'desc': desc,
    'hp': hp,
    'saveStr': saveStr,
    'saveDex': saveDex,
    'saveCon': saveCon,
    'saveInt': saveInt,
    'saveWis': saveWis,
    'saveCha': saveCha,
    'numOfSkills': numOfSkills,
    'skillIds': skillIds,
    'proficiencyIds': proficiencyIds,
    'feats': feats != null ? feats.map((i) => i.toMap()).toList() : null,
  };
}
