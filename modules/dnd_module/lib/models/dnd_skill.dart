part of dnd_module;

class DndSkill {
  int id;
  String name, desc, mod;

  DndSkill({
    this.id,
    this.name,
    this.desc,
    this.mod,
  });

  factory DndSkill.fromMap(Map<String, dynamic> data) => DndSkill(
    id: data['id'],
    name: data['name'],
    desc: data['desc'],
    mod: data['mod'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'desc': desc,
    'mod': mod,
  };
}
