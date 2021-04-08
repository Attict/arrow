part of dnd_module;

///
/// DndArmorBloc
///
///
class DndArmorBloc extends CoreBloc<CoreEvent, CoreState> {
  ///
  /// armor
  ///
  ///
  DndArmor armor;

  ///
  /// id
  ///
  ///
  int id;

  ///
  /// proficiencies
  ///
  /// Items with a type of Armor.
  ///
  List<DndProficiency> proficiencies;

  final typeValues = DndArmor.getTypeValues();
  final modValues = <int, String>{
    DndModifier.typeStr: 'Strength',
    DndModifier.typeDex: 'Dexterity',
    DndModifier.typeCon: 'Constitution',
    DndModifier.typeInt: 'Intelligence',
    DndModifier.typeWis: 'Wisdom',
    DndModifier.typeCha: 'Charisma',
  };

  ///
  /// currentProficiency
  ///
  ///
  DndProficiency get currentProficiency => proficiencies.firstWhere(
      (i) => i.id == armor.profId, orElse: () => null);

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
      f.add(id != null ? _service.getById(id) : Future.value(DndArmor()));
      f.add(_profService.getAllByType(DndProficiency.typeArmor));
      // Result
      final r = await Future.wait(f);
      armor = r[0];
      proficiencies = r[1];
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
      armor.id == null
          ? await _service.create(armor)
          : await _service.update(armor);
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
  final _service = DndArmorService();
  final _profService = DndProficiencyService();
}


