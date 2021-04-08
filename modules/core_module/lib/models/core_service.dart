part of core_module;

abstract class CoreService<T extends CoreModel> {
  ///
  /// route
  ///
  /// Virtual implementation.
  ///
  String get route;

  ///
  /// createObject
  ///
  /// Abstract implementation to create an object of generic type.
  ///
  T createObject(Map<String, dynamic> data);

  ///
  /// getAll
  ///
  ///
  Future<List<T>> getAll() async {
    final response = await CoreApplication.client.get('$route');
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return data.map<T>((i) => createObject(i)).toList();
  }

  ///
  /// getById
  ///
  ///
  Future<T> getById(int id) async {
    final response = await CoreApplication.client.get('$route/$id');
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return createObject(data);
  }


  ///
  /// create
  ///
  ///
  Future<Null> create(T t) async {
    final body = jsonEncode(t.toMap());
    final response = await CoreApplication.client.post('$route', body: body);
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }

  ///
  /// update
  ///
  ///
  Future<Null> update(T t) async {
    final body = jsonEncode(t.toMap());
    final response = await CoreApplication.client.put('$route', body: body);
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }

  ///
  /// delete
  ///
  ///
  Future<Null> delete(T t) async {
    final response = await CoreApplication.client.delete('$route/${t.id}');
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }

  ///
  /// deleteAll
  ///
  ///
  Future<Null> deleteAll(List<T> l) async {
    final ids = jsonEncode(l.map<int>((i) => i.id).toList());
    print('delete all on route "$route/$ids"');
    return; // FIXME
    final response = await CoreApplication.client.delete('$route/$ids');
    if (response.statusCode != 202) {
      throw CoreException.fromResponse(response);
    }
  }
}
