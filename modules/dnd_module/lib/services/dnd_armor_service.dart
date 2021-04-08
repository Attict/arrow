part of dnd_module;

class DndArmorService extends CoreService<DndArmor> {
  final String route = '${CoreApplication.instance.config.api}/dnd/armors';

  @override
  DndArmor createObject(Map<String, dynamic> data) => DndArmor.fromMap(data);
}
