part of dnd_module;

class DndArchetype implements CoreModel {
  int id;
  int classId;
  String name;
  String desc;

  DndArchetype({
    this.id,
    this.classId,
    this.name,
    this.desc,
  });

  factory DndArchetype.fromMap(Map<String, dynamic> data) => DndArchetype(
    id: data['id'],
    classId: data['classId'],
    name: data['name'],
    desc: data['desc'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'classId': classId,
    'name': name,
    'desc': desc,
  };
}
