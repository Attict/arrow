///
/// core_authentication_bloc.dart
/// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric.wagner@kapioshealth.com>
/// Created: December 9, 2019
///
part of core_module;

enum CoreAuthenticationEvent {
  authenticate,
}

///
/// CoreAuthenticationBloc
///
/// This is essentially the Login Bloc, but following naming convention.
///
class CoreAuthenticationBloc
extends CoreBloc<CoreAuthenticationEvent, CoreState> {
  ///
  /// authentication
  ///
  /// Used for setting `username` and `password`.
  final authentication = CoreAuthentication();

  @override
  void onEvent(CoreAuthenticationEvent event) {
    switch (event) {
      case CoreAuthenticationEvent.authenticate:
        _authenticate();
        break;
      default:
    }
  }

  @override
  void onError(Object e, [StackTrace stackTrace]) {
    CoreApplication.instance.handleException(e);
    setState(CoreState.error);
  }

  ///
  /// _authenticate
  ///
  /// Attempts to sign the user in.
  ///
  Future<Null> _authenticate() async {
    try {
      CoreApplication.instance.add(CoreEvent.load);
      setState(CoreState.loading);
      final auth = CoreAuthentication()
          ..username = authentication.username?.toLowerCase()
          ..password = authentication.password;
      final data = await _service.authenticate(auth);
      CoreApplication.instance.login(data);
      setState(CoreState.loaded);
    } catch(e) {
      onError(e);
    } finally {
      CoreApplication.instance.add(CoreEvent.loaded);
    }
  }

  ///
  /// _service
  ///
  /// The classes service.
  ///
  final _service = CoreAuthenticationService();
}
