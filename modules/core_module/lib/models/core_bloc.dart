///
/// core_bloc.dart
/// ~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <attictt@gmail.com>
///
///
part of core_module;

///
/// CoreBloc
///
/// Base controller for all things.
///
abstract class CoreBloc<Event, State>
extends Stream<State> implements Sink<Event> {
  ///
  /// setState
  ///
  ///
  void setState(State state) => _state.add(state);

  ///
  /// onEvent
  ///
  /// Meant to be overridden
  ///
  void onEvent(Event event) => null;

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
  StreamSubscription<State> listen(void onData(State value), {
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
  void add(Event event) {
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
  final _state = StreamController<State>();

  ///
  /// _event
  ///
  /// Events which are pushed into the [bloc], then in turn, update
  /// the [_state]
  ///
  final _event = StreamController<Event>();
}
