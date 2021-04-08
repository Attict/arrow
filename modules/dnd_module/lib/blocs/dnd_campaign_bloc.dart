part of dnd_module;

///
/// DndCampaignBloc
///
///
class DndCampaignBloc extends CoreBloc<CoreEvent, CoreState> {
  ///
  /// campaign
  ///
  ///
  DndCampaign campaign;

  ///
  /// id
  ///
  ///
  int id;

  ///
  /// characters
  ///
  /// Characters that are associated with this campaign.
  ///
  List<DndCharacter> characters;

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
      f.add(id != null ? _characterService.getAllByCampaign(id) : Future.value(null));
      // Result
      final r = await Future.wait(f);
      campaign = r[0] ?? DndCampaign();
      characters = r[1] ?? List<DndCharacter>();
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
      campaign.id == null
          ? await _service.create(campaign)
          : await _service.update(campaign);
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
  final _service = DndCampaignService();
  final _characterService = DndCharacterService();
}


