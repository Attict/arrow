part of dnd_module;

///
/// DndClassBloc
///
///
class DndFeatBloc extends CoreBloc<CoreEvent, CoreState> {
  ///
  /// class
  ///
  ///
  DndFeat feat;

  ///
  /// id
  ///
  ///
  int id;

  ///
  /// typeValues
  ///
  ///
  final typeValues = DndFeat.getTypeValues();

  ///
  /// modValues
  ///
  ///
  final modValues = <String, String>{
    'none': 'None',
    'str': 'Strength',
    'dex': 'Dexterity',
    'con': 'Constitution',
    'int': 'Intelligence',
    'wis': 'Wisdom',
    'cha': 'Charisma',
  };

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
      feat = r[0] ?? DndFeat();
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
      feat.id == null
          ? await _service.create(feat)
          : await _service.update(feat);
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
  final _service = DndFeatService();
  final _skillService = DndSkillService();
}


