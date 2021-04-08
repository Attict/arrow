part of core_module;

///
/// DndClassBloc
///
///
class CoreUserBloc extends CoreBloc<CoreEvent, CoreState> {
  ///
  /// class
  ///
  ///
  CoreUser user;

  ///
  /// id
  ///
  ///
  int id;

  ///
  /// skills
  ///
  ///
  List<CoreGroup> groups;

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
      f.add(id != null ? _service.getById(id) : Future.value(CoreUser()));
      f.add(_groupService.getAll());
      // Result
      final r = await Future.wait(f);
      user = r[0];
      groups = r[1];
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
      user.id == null
          ? await _service.create(user)
          : await _service.update(user);
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
  final _service = CoreUserService();
  final _groupService = CoreGroupService();
}

