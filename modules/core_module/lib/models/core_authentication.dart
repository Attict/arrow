part of core_module;

class CoreAuthentication {
  String username;
  String password;

  Map<String, dynamic> toMap() => {
    'username': username,
    'password': password,
  };
}
