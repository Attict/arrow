part of dnd_module;

class DndCharacterService extends CoreService<DndCharacter> {
  final route = '${CoreApplication.instance.config.api}/dnd/characters';

  DndCharacter createObject(Map<String, dynamic> data)
      => DndCharacter.fromMap(data);

  Future<List<DndCharacter>> getAllByCampaign(int id) async {
    final response = await http.get('$route/campaign/$id');
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return data.map<DndCharacter>((i) => DndCharacter.fromMap(i)).toList();
  }

  @override
  Future<List<DndCharacter>> getAll() async {
    final headers = await CoreApplication.instance.getHeaders();
    final response = await http.get('$route', headers: headers);
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return data.map<DndCharacter>((i) => DndCharacter.fromMap(i)).toList();
  }

  Future<String> generateHtml(DndCharacter character) async {
    final api = CoreApplication.instance.config.api;
    final body = jsonEncode(character.toMap());
    final response = await http.post('$api/dnd/character-sheet', body: body);
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    return response.body;
  }
}
