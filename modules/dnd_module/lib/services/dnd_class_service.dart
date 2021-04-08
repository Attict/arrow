part of dnd_module;

class DndClassService {
  String get route => '${CoreApplication.instance.config.api}/dnd/classes';

  ///
  /// getAll
  ///
  ///
  Future<List<DndClass>> getAll() async {
    final response = await http.get('$route');
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return data.map<DndClass>((i) => DndClass.fromMap(i)).toList();
  }

  ///
  /// getById
  ///
  ///
  Future<DndClass> getById(int id) async {
    final response = await http.get('$route/$id');
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return DndClass.fromMap(data);
  }

  ///
  /// create
  ///
  ///
  Future<Null> create(DndClass c) async {
    final body = jsonEncode(c.toMap());
    final response = await http.post('$route', body: body);
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }

  ///
  /// update
  ///
  ///
  Future<Null> update(DndClass c) async {
    final body = jsonEncode(c.toMap());
    final response = await http.put('$route', body: body);
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }

  ///
  /// delete
  ///
  ///
  Future<Null> delete(DndClass c) async {
    final response = await http.delete('$route/${c.id}');
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }
}
