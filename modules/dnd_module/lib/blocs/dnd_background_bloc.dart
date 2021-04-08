part of dnd_module;

///
/// DndClassBloc
///
///
class DndBackgroundBloc extends CoreBloc<CoreEvent, CoreState> {
  ///
  /// class
  ///
  ///
  DndBackground background;

  ///
  /// id
  ///
  ///
  int id;

  ///
  /// skills
  ///
  ///
  List<DndSkill> skills;

  ///
  /// selectedSkills
  ///
  ///
  List<bool> selectedSkills;

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
      f.add(_skillService.getAll());
      // Result
      final r = await Future.wait(f);
      background = r[0] ?? DndBackground();
      skills = r[1];
      selectedSkills = List<bool>.generate(skills.length,
          (i) => background.skillIds?.contains(skills[i].id) ?? false);
      _loadSkills();
      // Done
      setState(CoreState.loaded);
    } catch (e) {
      onError(e);
    } finally {
      CoreApplication.instance.add(CoreEvent.loaded);
    }
  }


  void _loadSkills() {
    if (background.skillIds == null) {
      return;
    }
    // Set selected skills
    for (int i = 0; i < skills.length; i++) {
      final s = background.skillIds.firstWhere(
          (j) => j == skills[i].id, orElse: () => null);
      if (s != null) {
        selectedSkills[i] = true;
      }
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
      _saveSkills();
      // Create or Update
      background.id == null
          ? await _service.create(background)
          : await _service.update(background);
      setState(CoreState.saved);
    } catch (e) {
      onError(e);
    } finally {
      CoreApplication.instance.add(CoreEvent.loaded);
    }
  }

  ///
  /// _saveSkills
  ///
  ///
  void _saveSkills() {
    // Set selected skills
    background.skillIds = List<int>();
    for (int i = 0; i < skills.length; i++) {
      if (selectedSkills[i]) {
        background.skillIds.add(skills[i].id);
      }
    }
  }

  ///
  /// _service
  ///
  ///
  final _service = DndBackgroundService();
  final _skillService = DndSkillService();
}

