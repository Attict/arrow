part of dnd_module;

class DndBackgroundService {
  String get route => '${CoreApplication.instance.config.api}/dnd/backgrounds';

  ///
  /// getAll
  ///
  ///
  Future<List<DndBackground>> getAll() async {
    final response = await http.get('$route');
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return data.map<DndBackground>((i) => DndBackground.fromMap(i)).toList();
  }

  ///
  /// getById
  ///
  ///
  Future<DndBackground> getById(int id) async {
    final response = await http.get('$route/$id');
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return DndBackground.fromMap(data);
  }


  ///
  /// create
  ///
  ///
  Future<Null> create(DndBackground b) async {
    final body = jsonEncode(b.toMap());
    final response = await http.post('$route', body: body);
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }

  ///
  /// update
  ///
  ///
  Future<Null> update(DndBackground b) async {
    final body = jsonEncode(b.toMap());
    final response = await http.put('$route', body: body);
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }

  ///
  /// delete
  ///
  ///
  Future<Null> delete(DndBackground b) async {
    final response = await http.delete('$route/${b.id}');
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }
}
