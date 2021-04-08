part of dnd_module;

class DndStatus implements CoreModel {
  int id;
  int userId;
  int characterId;
  String message;
  DateTime created;
  DateTime modified;

  DndStatus({
    this.id,
    this.userId,
    this.characterId,
    this.message,
    this.created,
    this.modified,
  });

  factory DndStatus.fromMap(Map<String, dynamic> data) => DndStatus(
    id: data['id'],
    userId: data['userId'],
    characterId: data['characterId'],
    message: data['message'],
    created: data['created'] != null ? DateTime.parse(data['created']) : null,
    modified: data['modified'] != null
        ? DateTime.parse(data['modified']) : null,
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'characterId': characterId,
    'message': message,
    'created': created != null ? created.toString() : null,
    'modified': modified != null ? modified.toString() : null,
  };
}
