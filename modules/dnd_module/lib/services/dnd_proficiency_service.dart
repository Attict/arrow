part of dnd_module;

class DndProficiencyService {
  String get route => '${CoreApplication.instance.config.api}/dnd/proficiencies';

  ///
  /// getAll
  ///
  ///
  Future<List<DndProficiency>> getAll() async {
    final response = await http.get('$route');
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return data.map<DndProficiency>((i) => DndProficiency.fromMap(i)).toList();
  }

  ///
  /// getAllByType
  ///
  ///
  Future<List<DndProficiency>> getAllByType(int type) async {
    final response = await http.get('$route/type/$type');
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return data.map<DndProficiency>((i) => DndProficiency.fromMap(i)).toList();
  }

  ///
  /// getById
  ///
  ///
  Future<DndProficiency> getById(int id) async {
    final response = await http.get('$route/$id');
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return DndProficiency.fromMap(data);
  }


  ///
  /// create
  ///
  ///
  Future<Null> create(DndProficiency p) async {
    final body = jsonEncode(p.toMap());
    final response = await http.post('$route', body: body);
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }

  ///
  /// update
  ///
  ///
  Future<Null> update(DndProficiency p) async {
    final body = jsonEncode(p.toMap());
    final response = await http.put('$route', body: body);
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }

  ///
  /// delete
  ///
  ///
  Future<Null> delete(DndProficiency p) async {
    final response = await http.delete('$route/${p.id}');
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }
}
