part of dnd_module;

///
/// DndWeaponBloc
///
///
class DndWeaponBloc extends CoreBloc<CoreEvent, CoreState> {
  ///
  /// weapon
  ///
  ///
  DndWeapon weapon;

  ///
  /// id
  ///
  ///
  int id;

  ///
  /// proficiencies
  ///
  /// Items with a type of Weapon.
  ///
  List<DndProficiency> proficiencies;

  final typeValues = DndWeapon.getTypeValues();
  final damageValues = DndWeapon.getDamageValues();
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
      (i) => i.id == weapon.profId, orElse: () => null);

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
      f.add(id != null ? _service.getById(id) : Future.value(DndWeapon()));
      f.add(_profService.getAllByType(DndProficiency.typeWeapon));
      // Result
      final r = await Future.wait(f);
      weapon = r[0];
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
      weapon.id == null
          ? await _service.create(weapon)
          : await _service.update(weapon);
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
  final _service = DndWeaponService();
  final _profService = DndProficiencyService();
}


