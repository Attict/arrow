part of dnd_module;

class DndFeatService extends CoreService<DndFeat> {
  String route = '${CoreApplication.instance.config.api}/dnd/feats';
  DndFeat createObject(Map<String, dynamic> data) => DndFeat.fromMap(data);

  Future<List<DndFeat>> getByType(int type) async {
    final response = await http.get('$route/type/$type');
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    final data = jsonDecode(response.body);
    return data.map<DndFeat>((i) => DndFeat.fromMap(i)).toList();
  }
}
