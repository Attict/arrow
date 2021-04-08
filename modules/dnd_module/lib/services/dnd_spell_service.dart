part of dnd_module;

class DndSpellService extends CoreService<DndSpell> {
  String route = '${CoreApplication.instance.config.api}/dnd/spells';
  DndSpell createObject(Map<String, dynamic> data) => DndSpell.fromMap(data);
}
