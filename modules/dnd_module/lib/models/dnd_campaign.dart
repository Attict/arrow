part of dnd_module;

class DndCampaign implements CoreModel {
  int id;
  int leaderId;
  String name;
  String desc;

  DndCampaign({
    this.id,
    this.leaderId,
    this.name,
    this.desc,
  });

  factory DndCampaign.fromMap(Map<String, dynamic> data) => DndCampaign(
    id: data['id'],
    leaderId: data['leaderId'],
    name: data['name'],
    desc: data['desc'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'leaderId': leaderId,
    'name': name,
    'desc': desc,
  };
}
