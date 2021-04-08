part of dnd_module;

class DndRaceService {
  String get route => '${CoreApplication.instance.config.api}/dnd/races';

  ///
  /// getAll
  ///
  ///
  Future<List<DndRace>> getAll() async {
    final response = await http.get('$route');
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return data.map<DndRace>((i) => DndRace.fromMap(i)).toList();
  }

  ///
  /// getById
  ///
  ///
  Future<DndRace> getById(int id) async {
    final response = await http.get('$route/$id');
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return DndRace.fromMap(data);
  }


  ///
  /// create
  ///
  ///
  Future<Null> create(DndRace r) async {
    final body = jsonEncode(r.toMap());
    final response = await http.post('$route', body: body);
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }

  ///
  /// update
  ///
  ///
  Future<Null> update(DndRace r) async {
    final body = jsonEncode(r.toMap());
    final response = await http.put('$route', body: body);
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }

  ///
  /// delete
  ///
  ///
  Future<Null> delete(DndRace r) async {
    final response = await http.delete('$route/${r.id}');
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }

  Future<Null> import(String data) async {
    final body = data;
    final response = await http.post('$route/import', body: body);
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }
}
