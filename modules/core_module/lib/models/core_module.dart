part of core_module;

class CoreModule implements CoreModel {
  int id;
  String label;
  bool enabled;

  CoreModule({
    this.id,
    this.label,
    this.enabled,
  });

  factory CoreModule.fromMap(Map<String, dynamic> data) {
    return CoreModule(
      id: data['id'],
      label: data['label'],
      enabled: data['enabled'],
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'label': label,
    'enabled': enabled,
  };
}
