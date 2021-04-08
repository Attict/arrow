part of dnd_module;

///
/// DndSpellBloc
///
///
class DndSpellBloc extends CoreBloc<CoreEvent, CoreState> {
  ///
  /// class
  ///
  ///
  DndSpell spell;

  ///
  /// id
  ///
  ///
  int id;

  ///
  /// typeValues
  ///
  ///
  final typeValues = DndSpell.getTypeValues();

  ///
  /// shapeValues
  ///
  ///
  final shapeValues = DndSpell.getShapeValues();

  ///
  /// saveValues
  ///
  ///
  final saveValues = DndSpell.getSaveValues();

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
      // Result
      final r = await Future.wait(f);
      spell = r[0] ?? DndSpell();
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
      spell.id == null
          ? await _service.create(spell)
          : await _service.update(spell);
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
  final _service = DndSpellService();
}


