part of dnd_module;

///
/// DndClassBloc
///
///
class DndArchetypeBloc extends CoreBloc<CoreEvent, CoreState> {
  ///
  /// class
  ///
  ///
  DndArchetype archetype;

  ///
  /// id
  ///
  ///
  int id;

  ///
  /// classes
  ///
  ///
  List<DndClass> classes;

  ///
  /// onEvent
  ///
  ///
  @override
  void onEvent(CoreEvent event) {
    switch (event) {
      case CoreEvent.load:
        _load();
        break;
      case CoreEvent.save:
        _save();
        break;
      default:
    }
  }

  ///
  /// onError
  ///
  ///
  @override
  void onError(Object e, [StackTrace stackTrace]) {
    CoreApplication.instance.handleException(e);
    setState(CoreState.error);
  }

  ///
  /// _load
  ///
  ///
  Future<void> _load() async {
    CoreApplication.instance.add(CoreEvent.load);
    setState(CoreState.loading);
    try {
      // Futures
      final f = List<Future>();
      f.add(id != null ? _service.getById(id) : Future.value(null));
      f.add(_classService.getAll());
      // Result
      final r = await Future.wait(f);
      archetype = r[0] ?? DndArchetype();
      classes = r[1];
      // Done
      setState(CoreState.loaded);
    } catch (e) {
      onError(e);
    } finally {
      CoreApplication.instance.add(CoreEvent.loaded);
    }
  }

  ///
  /// _save
  ///
  ///
  Future<void> _save() async {
    CoreApplication.instance.add(CoreEvent.load);
    setState(CoreState.saving);
    try {
      // Create or Update
      archetype.id == null
          ? await _service.create(archetype)
          : await _service.update(archetype);
      setState(CoreState.saved);
    } catch (e) {
      onError(e);
    } finally {
      CoreApplication.instance.add(CoreEvent.loaded);
    }
  }

  ///
  /// _service
  ///
  ///
  final _service = DndArchetypeService();
  final _classService = DndClassService();
}


