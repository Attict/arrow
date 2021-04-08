part of dnd_module;

class DndBackground {
  int id;
  String name, desc;
  List<DndSkill> skills;
  List<int> skillIds;

  DndBackground({
    this.id,
    this.name,
    this.desc,
    this.skillIds,
  });


  factory DndBackground.fromMap(Map<String, dynamic> data) => DndBackground(
    id: data['id'],
    name: data['name'],
    desc: data['desc'],
    skillIds: data['skillIds'] != null
        ? List<int>.from(data['skillIds']) : null,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'desc': desc,
    'skillIds': skillIds,
  };
}
