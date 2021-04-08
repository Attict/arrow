part of core_module;

///
/// CoreAuthenticationService
///
/// Communicates with the
///
class CoreAuthenticationService {
  ///
  /// route
  ///
  /// The base route for this service.
  ///
  String get route => '${CoreApplication.instance.config.api}/core/authentication';

  ///
  /// authenticate
  ///
  Future<Map<String, dynamic>> authenticate(CoreAuthentication auth) async {
    final body = jsonEncode(auth.toMap());
    final response = await CoreApplication.instance.config.client.post('$route', body: body);
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    return jsonDecode(response.body);
  }

  ///
  /// refresh
  ///
  ///
  Future<Map<String, dynamic>> refresh(CoreToken rt) async {
    final headers = <String, String>{
      'content-type': 'application/json',
      'Authorization': 'Bearer ${rt.value}',
    };
    final response = await http.post('$route/refresh', headers: headers);
    if (response.statusCode != 200) {
      throw CoreException.fromResponse(response);
    }
    return jsonDecode(response.body);
  }
}
