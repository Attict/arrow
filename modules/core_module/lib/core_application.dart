///
/// core_application.dart
/// ~~~~~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric@attict.net>
/// Created:
///
part of core_module;

///
/// CoreApplication
///
///
class CoreApplication extends Stream<CoreState> implements Sink<CoreEvent> {
  ///
  /// Singleton instance
  ///
  /// This is the core application which can be used acrossed the application
  /// at any time.  This uses a singleton instance to maintain state.
  ///
  /// Do NOT ever create a new instance using the `_private()` method.
  /// You may however use the base constructor to reference the instance
  /// as it's own property.
  ///
  static final instance = CoreApplication._private();
  factory CoreApplication() => instance;
  CoreApplication._private();

  ///
  /// client
  ///
  /// Shorthand to get the client.
  ///
  static http.Client get client => instance.config.client;

  ///
  /// client
  ///
  /// Shortcut for referencing the cliient.

  ///
  /// title
  ///
  /// A dynamic title that can either be the app na
  ///
  String title = 'Application';


  ///
  /// api
  ///
  /// FIXME:
  /// - This might belong inside a [config] object.
  ///
  CoreConfig config = CoreConfig();
  @Deprecated('Not sure this will remain, in favor of config.storage')
  CoreStorage get storage => config.storage;

  ///
  /// user
  ///
  /// Not used, considered always signed in.
  ///
  CoreUser get user => _user;
  CoreUser _user;

  ///
  /// dialog
  ///
  ///
  CoreDialog dialog;
  void closeDialog() => dialog = null;

  ///
  /// init
  ///
  ///
  void init() {
    //final r = config.storage.getToken('refresh_token');
    //if (r == null) {
    //  logout();
    //  return;
    //}

    final userData = config.storage.load('user');
    if (userData != null) {
      _user = CoreUser.fromMap(userData);
    }
  }

  ///
  /// login
  ///
  ///
  void login(Map<String, dynamic> data) {
    _user = CoreUser.fromMap(data['user']);
    config.storage
        ..save('user', data['user']);
        //..addToken(CoreToken(
        //  'access_token',
        //  data['accessToken'],
        //  expires: DateTime.now().add(Duration(minutes: 5)),
        //))
        //..addToken(CoreToken(
        //  'refresh_token',
        //  data['refreshToken'],
        //  expires: DateTime.now().add(Duration(hours: 24)),
        //));
  }

  ///
  /// logout
  ///
  ///
  void logout() {
    _user = null;
    config.storage
        ..delete('user');
  }

  /// getHeaders
  ///
  /// Used to attach the appropriate authorization header to requests.
  /// Optionally appending to a pre-existing map of headers.
  ///
  /// headers Additional headers to be provided with the returned
  /// headers.
  /// The final headers to be sent with the request.
  ///
  Future<Map<String, String>> getHeaders({Map<String, String> headers}) async {
    headers = (headers != null) ? headers : Map<String, String>();
    try {
      // Defaults to JSON
      if (headers['content-type'] == null) {
        headers['content-type'] = 'application/json';
      }

      // Attempt to refresh the access token
      //CoreToken at = config.storage.getToken('access_token');
      //if (at == null) {
      //  final rt = config.storage.getToken('refresh_token');
      //  if (rt == null) {
      //    logout();
      //    return null;
      //  }
      //  final service = CoreAuthenticationService();
      //  final data = await service.refresh(rt);
      //  at = CoreToken('access_token', data['accessToken'],
      //      expires: DateTime.now().add(Duration(minutes: 5)));
      //  config.storage
      //      ..save('user', data['user'])
      //      ..addToken(at);
      //}
      //headers['Authorization'] = 'Bearer ${at.value}';
    } catch (e) {
      handleException(e);
    }
    return headers;
  }

  ///
  /// handleException
  ///
  /// This is used to handle thrown exceptions, primarily from the server.
  /// However it can be used for any exception handling, and is meant to
  /// create a simple way to show a dialog with the error that has occurred.
  ///
  void handleException(dynamic e) {
    if (e is CoreException) {
      dialog = CoreDialog.fromException(e);
    } else {
      dialog = CoreDialog(
        title: 'Exception Thrown',
        message: e.toString(),
        buttons: <CoreDialogButton>[CoreDialogButton.close()],
      );
    }
    print(StackTrace.current);
  }

  ///
  /// onEvent
  ///
  /// Meant to be overridden
  ///
  void onEvent(CoreEvent event) {
    switch (event) {
      case CoreEvent.load:
        if (_loading == 0) {
          _state.add(CoreState.loading);
        }
        _loading++;
        break;
      case CoreEvent.loaded:
        _loading--;
        if (_loading < 1) {
          _state.add(CoreState.loaded);
        }
        break;
      case CoreEvent.unload:
        _loading = 0;
        _state.add(CoreState.loaded);
        break;
      default:
    }
  }

  ///
  /// onError
  ///
  /// Meant to be overridden.
  ///
  void onError(Object error, [StackTrace stacktrace]) => null;

  ///
  /// listen
  ///
  /// Listen to the [state] for updates.
  ///
  StreamSubscription<CoreState> listen(void onData(CoreState value), {
    Function onError,
    void onDone(),
    bool cancelOnError
  }) {
    return _state.stream.listen(onData, onError: onError,
        onDone: onDone, cancelOnError: cancelOnError);
  }

  ///
  /// add
  ///
  /// Pushes an event to update the state.
  ///
  @override
  void add(CoreEvent event) {
    try {
      onEvent(event);
      _event.add(event);
    } catch (error) {
      onError(error);
    }
  }

  ///
  /// close
  ///
  /// Dispose of the current [bloc] events.
  ///
  @override
  Future<void> close() async {
    await _event.close();
    await _state.close();
  }

  ///
  /// _state
  ///
  /// The state of the current [bloc], updated through [_event].
  ///
  final _state = StreamController<CoreState>.broadcast();

  ///
  /// _event
  ///
  /// Events which are pushed into the [bloc], then in turn, update
  /// the [_state]
  ///
  final _event = StreamController<CoreEvent>();

  ///
  /// _loading
  ///
  /// Count for each service loading.
  ///
  int _loading = 0;
}
