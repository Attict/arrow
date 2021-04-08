part of dnd_module;

class DndWeaponService extends CoreService<DndWeapon> {
  final String route = '${CoreApplication.instance.config.api}/dnd/weapons';

  @override
  DndWeapon createObject(Map<String, dynamic> data) => DndWeapon.fromMap(data);
}
