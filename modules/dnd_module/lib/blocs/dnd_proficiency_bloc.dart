part of dnd_module;

///
/// DndProficiencyBloc
///
///
class DndProficiencyBloc extends CoreBloc<CoreEvent, CoreState> {
  ///
  /// class
  ///
  ///
  DndProficiency proficiency;

  ///
  /// id
  ///
  ///
  int id;

  ///
  /// typeValues
  ///
  ///
  final typeValues = DndProficiency.getTypeValues();

  ///
  /// skills
  ///
  ///
  List<DndSkill> skills;

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

  String getSkillName(int id) =>
      skills.firstWhere((s) => s.id == id, orElse: () => null)?.name;

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
      f.add(_skillService.getAll());
      // Result
      final r = await Future.wait(f);
      proficiency = r[0] ?? DndProficiency();
      skills = r[1];
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
      proficiency.id == null
          ? await _service.create(proficiency)
          : await _service.update(proficiency);
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
  final _service = DndProficiencyService();
  final _skillService = DndSkillService();
}


