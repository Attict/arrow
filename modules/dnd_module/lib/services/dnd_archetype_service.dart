part of dnd_module;

class DndArchetypeService extends CoreService<DndArchetype> {
  String route = '${CoreApplication.instance.config.api}/dnd/archetypes';
  DndArchetype createObject(Map<String, dynamic> data) => DndArchetype.fromMap(data);
}
