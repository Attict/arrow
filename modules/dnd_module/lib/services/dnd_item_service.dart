part of dnd_module;

class DndItemService {
  String get route => '${CoreApplication.instance.config.api}/dnd/items';

  ///
  /// getAll
  ///
  ///
  Future<List<DndItem>> getAll() async {
    final response = await http.get('$route');
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return data.map<DndItem>((i) => DndItem.fromMap(i)).toList();
  }

  ///
  /// getAllByType
  ///
  /// Provide type from [DndItem] static property.
  ///
  Future<List<DndItem>> getAllByType(int type) async {
    final response = await http.get('$route/type/$type');
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return data.map<DndItem>((i) => DndItem.fromMap(i)).toList();
  }

  ///
  /// getById
  ///
  ///
  Future<DndItem> getById(int id) async {
    final response = await http.get('$route/$id');
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return DndItem.fromMap(data);
  }


  ///
  /// create
  ///
  ///
  Future<Null> create(DndItem p) async {
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
  Future<Null> update(DndItem p) async {
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
  Future<Null> delete(DndItem p) async {
    final response = await http.delete('$route/${p.id}');
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }
}
