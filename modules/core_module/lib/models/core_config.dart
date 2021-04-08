part of core_module;

enum CoreEnvironment {
  development,
  testing,
  production,
}

class CoreConfig {
  final CoreEnvironment environment;
  final String api;
  final CoreStorage storage;
  final http.BaseClient client;

  const CoreConfig({
    this.environment: CoreEnvironment.production,
    this.api: '/api',
    this.storage,
    this.client,
  });
}
