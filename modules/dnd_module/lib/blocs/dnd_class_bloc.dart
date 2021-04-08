part of dnd_module;

///
/// DndClassBloc
///
///
class DndClassBloc extends CoreBloc<CoreEvent, CoreState> {
  ///
  /// class
  ///
  ///
  DndClass c;

  ///
  /// id
  ///
  ///
  int id;

  ///
  /// hpOptions
  ///
  ///
  final hpOptions = [2, 4, 6, 8, 10, 12, 20, 100];

  ///
  /// skills
  ///
  ///
  List<DndSkill> skills;
  List<bool> selectedSkills;

  ///
  /// proficiencies
  ///
  ///
  List<DndProficiency> proficiencies;

  ///
  /// getSkillName
  ///
  ///
  String getSkillName(int id) =>
      skills.firstWhere((s) => s.id == id, orElse: () => null)?.name;

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
      f.add(_proficiencyService.getAll());
      // Result
      final r = await Future.wait(f);
      c = r[0] ?? DndClass();
      skills = r[1];
      proficiencies = r[2];

      selectedSkills = List<bool>.generate(skills.length,
          (i) => c.skillIds?.contains(skills[i].id) ?? false);
      c.skills = List<DndSkill>();
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
    if (c.skillIds == null) {
      return;
    }
    // Set selected skills
    for (int i = 0; i < skills.length; i++) {
      final s = c.skillIds.firstWhere(
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
      c.id == null
          ? await _service.create(c)
          : await _service.update(c);
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
    c.skillIds = List<int>();
    for (int i = 0; i < skills.length; i++) {
      if (selectedSkills[i]) {
        c.skillIds.add(skills[i].id);
      }
    }
  }

  ///
  /// _service
  ///
  ///
  final _service = DndClassService();
  final _skillService = DndSkillService();
  final _proficiencyService = DndProficiencyService();
}

