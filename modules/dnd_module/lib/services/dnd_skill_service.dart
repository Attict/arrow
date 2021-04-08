part of dnd_module;

class DndSkillService {
  String get route => '${CoreApplication.instance.config.api}/dnd/skills';

  ///
  /// getAll
  ///
  ///
  Future<List<DndSkill>> getAll() async {
    final response = await http.get('$route');
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return data.map<DndSkill>((i) => DndSkill.fromMap(i)).toList();
  }
}
