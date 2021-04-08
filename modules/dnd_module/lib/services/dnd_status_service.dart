part of dnd_module;

class DndStatusService extends CoreService<DndStatus> {
  final String route = '${CoreApplication.instance.config.api}/dnd/statuses';

  @override
  DndStatus createObject(Map<String, dynamic> data) => DndStatus.fromMap(data);
}
