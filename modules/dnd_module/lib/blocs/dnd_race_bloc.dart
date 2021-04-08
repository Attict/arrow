part of dnd_module;

///
/// DndRaceBloc
///
///
class DndRaceBloc extends CoreBloc<CoreEvent, CoreState> {
  ///
  /// race
  ///
  ///
  DndRace race;

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
      final f = List<Future>();
      f.add(id != null ? _service.getById(id) : Future.value(DndRace()));
      f.add(_skillService.getAll());
      f.add(_proficiencyService.getAll());
      final r = await Future.wait(f);
      race = r[0];
      skills = r[1];
      proficiencies = r[2];
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
      race.id == null
          ? await _service.create(race)
          : await _service.update(race);
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
  final _service = DndRaceService();
  final _skillService = DndSkillService();
  final _proficiencyService = DndProficiencyService();
}
