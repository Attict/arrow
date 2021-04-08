part of dnd_module;

class DndCharacterBloc extends CoreBloc<CoreEvent, CoreState> {
  ///
  /// character
  ///
  ///
  DndCharacter character;

  ///
  /// id
  ///
  ///
  int id;

  ///
  /// races
  ///
  ///
  List<DndRace> races;

  ///
  /// backgrounds
  ///
  ///
  List<DndBackground> backgrounds;

  ///
  /// classes
  ///
  ///
  List<DndClass> classes;

  ///
  /// archetypes
  ///
  ///
  List<DndArchetype> archetypes;

  ///
  /// armors
  ///
  ///
  List<DndArmor> armors;

  ///
  /// skills
  ///
  ///
  List<DndSkill> skills;

  ///
  /// campaigns
  ///
  ///
  List<DndCampaign> campaigns;

  ///
  /// proficiencies
  ///
  ///
  List<DndProficiency> proficiencies;

  ///
  /// Feats
  ///
  ///
  List<DndFeat> feats;

  ///
  /// items
  ///
  ///
  List<DndItem> items;

  ///
  /// weapons
  ///
  ///
  List<DndWeapon> weapons;

  ///
  /// alignments
  ///
  ///
  final alignments = <String>[
    'Lawful Good',
    'Neutral Good',
    'Chaotic Good',
    'Lawful Neutral',
    'Neutral',
    'Chaotic Neutral',
    'Lawful Evil',
    'Neutral Evil',
    'Chaotic Evil',
  ];

  ///
  /// classSkills
  ///
  ///
  List<DndSkill> classSkills;

  ///
  /// backgroundSkills
  ///
  ///
  List<DndSkill> backgroundSkills;

  ///
  /// currentRace
  ///
  ///
  DndRace get currentRace => _currentRace;
  set currentRace(DndRace r) {
    if (r == null) return;
    character.raceId = r.id;
    _currentRace = r;
    _currentRaceFeats =
        _currentRace.featPoints != null && _currentRace.featPoints > 0
        ? List<DndFeat>(_currentRace.featPoints) : null;
    _currentRaceAttrs =
        _currentRace.attrPoints != null && _currentRace.attrPoints > 0
        ? List<DndModifier>(_currentRace.attrPoints) : null;
  }
  DndRace _currentRace;

  ///
  /// currentRaceFeats
  ///
  List<DndFeat> get currentRaceFeats => _currentRaceFeats;
  List<DndFeat> _currentRaceFeats;
  List<DndModifier> get currentRaceAttrs => _currentRaceAttrs;
  List<DndModifier> _currentRaceAttrs;


  ///
  /// currentBackground
  ///
  ///
  DndBackground get currentBackground => _currentBackground;
  set currentBackground(DndBackground b) {
    if (b == null) return;
    backgroundSkills = List<DndSkill>();
    for (final sid in b.skillIds) {
      final s = skills.firstWhere((i) => i.id == sid, orElse: () => null);
      if (s != null) {
        backgroundSkills.add(s);
      }
    }
    character.backgroundId = b.id;
    _currentBackground = b;
  }
  DndBackground _currentBackground;

  ///
  /// currentClass
  ///
  ///
  DndClass get currentClass => _currentClass;
  set currentClass(DndClass c) {
    if (c == null) return;
    classSkills = List<DndSkill>();
    for (final sid in c.skillIds) {
      final s = skills.firstWhere((i) => i.id == sid, orElse: () => null);
      if (s != null) {
        classSkills.add(s);
      }
    }
    currentSkills = List<DndSkill>(c.numOfSkills);
    character.classId = c.id;
    _currentClass = c;
  }
  DndClass _currentClass;

  ///
  /// currentArchetype
  ///
  ///
  DndArchetype get currentArchetype => _currentArchetype;
  set currentArchetype(DndArchetype a) {
    if (a == null) return;
    character.archetypeId = a.id;
    _currentArchetype = a;
  }
  DndArchetype _currentArchetype;

  ///
  /// currentSkills
  ///
  ///
  List<DndSkill> get currentSkills => _currentSkills;
  set currentSkills(List<DndSkill> skills) {
    _currentSkills = skills;
  }
  List<DndSkill> _currentSkills;

  ///
  /// languageProficiencies
  ///
  /// Proficiencies where `type` matches language.
  ///
  List<DndProficiency> get languageProficiencies {
    final profs = List<int>()
        ..addAll(currentRace.proficiencyIds)
        ..addAll(currentClass.proficiencyIds);
    return proficiencies.where((i) => i.type == DndProficiency.typeLanguage
        && profs.contains(i.id)).toList();
  }

  ///
  /// itemProficiencies
  ///
  /// Proficiencies where
  List<DndProficiency> get itemProficiencies {
    final profs = List<int>()
        ..addAll(currentRace.proficiencyIds)
        ..addAll(currentClass.proficiencyIds);
    return proficiencies.where((i) => i.type != DndProficiency.typeLanguage
        && profs.contains(i.id)).toList();
  }

  List<DndFeat> get allFeats {

    final r = List<DndFeat>.from(currentRace.feats)
        ..addAll(currentClass.feats.where((i) => character.level >= i.level))
        ..addAll(feats.where((i) => character.featIds?.contains(i.id) ?? false));
    return r;
  }

  List<DndItem> get allItems {
    return weapons.map<DndItem>((w) => w.item..id = w.id).toList()
        ..addAll(armors.map<DndItem>((a) => a.item..id = a.id).toList())
        ..addAll(items);
  }

  ///
  /// totals
  ///
  int get totalStr {
    int mod = 0;
    if (character.mods != null) {
      for (final m in character.mods) {
        if (m.type == DndModifier.typeAttr && m.subtype == DndModifier.typeStr) {
          mod += m.value;
        }
      }
    }
    return character.strength + currentRace.strength + mod;
  }
  int get totalDex {
    int mod = 0;
    if (character.mods != null) {
      for (final m in character.mods) {
        if (m.type == DndModifier.typeAttr && m.subtype == DndModifier.typeDex) {
          mod += m.value;
        }
      }
    }
    return character.dexterity + currentRace.dexterity + mod;
  }
  int get totalCon {
    int mod = 0;
    if (character.mods != null) {
      for (final m in character.mods) {
        if (m.type == DndModifier.typeAttr && m.subtype == DndModifier.typeCon) {
          mod += m.value;
        }
      }
    }
    return character.constitution + currentRace.constitution + mod;
  }
  int get totalInt {
    int mod = 0;
    if (character.mods != null) {
      for (final m in character.mods) {
        if (m.type == DndModifier.typeAttr && m.subtype == DndModifier.typeInt) {
          mod += m.value;
        }
      }
    }
    return character.intelligence + currentRace.intelligence + mod;
  }
  int get totalWis {
    int mod = 0;
    if (character.mods != null) {
      for (final m in character.mods) {
        if (m.type == DndModifier.typeAttr && m.subtype == DndModifier.typeWis) {
          mod += m.value;
        }
      }
    }
    return character.wisdom + currentRace.wisdom + mod;
  }
  int get totalCha {
    int mod = 0;
    if (character.mods != null) {
      for (final m in character.mods) {
        if (m.type == DndModifier.typeAttr && m.subtype == DndModifier.typeCha) {
          mod += m.value;
        }
      }
    }
    return character.charisma + currentRace.charisma + mod;
  }
  int get modStr => ((totalStr - 10) / 2).floor();
  int get modDex => ((totalDex - 10) / 2).floor();
  int get modCon => ((totalCon - 10) / 2).floor();
  int get modInt => ((totalInt - 10) / 2).floor();
  int get modWis => ((totalWis - 10) / 2).floor();
  int get modCha => ((totalCha - 10) / 2).floor();
  int get saveStr => modStr + (currentClass.saveStr ? prof : 0);
  int get saveDex => modDex + (currentClass.saveDex ? prof : 0);
  int get saveCon => modCon + (currentClass.saveCon ? prof : 0);
  int get saveInt => modInt + (currentClass.saveInt ? prof : 0);
  int get saveWis => modWis + (currentClass.saveWis ? prof : 0);
  int get saveCha => modCha + (currentClass.saveCha ? prof : 0);

  ///
  /// generate
  ///
  /// requests the html template for the character sheet to be printed.
  ///
  Future<String> generate() async {
    character.backgroundId = currentBackground?.id;
    character.classId = currentClass?.id;
    character.raceId = currentRace?.id;
    character.skillIds = currentSkills != null
        ? currentSkills.map<int>((i) => i?.id).toList()
        : null;
    return _service.generateHtml(character);
  }

  DndCampaign currentCampaign() => campaigns.firstWhere(
      (i) => i.id == character.campaignId, orElse: () => null);

  ///
  /// loadCharacter
  ///
  ///
  void loadCharacter(Map<String, dynamic> data) {
    character = DndCharacter.fromMap(data);
    currentClass = classes.firstWhere((i) =>
        i.id == character.classId, orElse: () => null);
    currentArchetype = archetypes.firstWhere((i) =>
        i.id == character.archetypeId, orElse: () => null);
    currentRace = races.firstWhere((i) =>
        i.id == character.raceId, orElse: () => null);
    currentBackground = backgrounds.firstWhere((i) =>
        i.id == character.backgroundId, orElse: () => null);
    currentSkills = skills.where((s) => character.skillIds.firstWhere(
          (j) => j == s.id, orElse: () => null) != null).toList();
  }

  Map<String, dynamic> saveCharacter() {
    character.backgroundId = currentBackground?.id;
    character.classId = currentClass?.id;
    character.archetypeId = currentArchetype?.id;
    character.raceId = currentRace?.id;
    character.skillIds = currentSkills != null
        ? currentSkills.map<int>((i) => i?.id).toList()
        : null;
    return character.toMap()..remove('id');
  }


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

  @override
  void onError(Object e, [StackTrace stackTrace]) {
    CoreApplication.instance.handleException(e);
    setState(CoreState.error);
  }

  List<DndArchetype> get classArchetypes {
    return archetypes.where((i) => i.classId == character.classId).toList();
  }

  int get prof {
    if (character.level > 16) {
      return 6;
    } else if (character.level > 12) {
      return 5;
    } else if (character.level > 8) {
      return 4;
    } else if (character.level > 4) {
      return 3;
    }
    return 2;
  }

  Future<void> _load() async {
    try {
      CoreApplication.instance.add(CoreEvent.load);
      final f = List<Future>();
      f.add(id != null ? _service.getById(id) : Future.value(null));
      f.add(_archetypeService.getAll());
      f.add(_armorService.getAll());
      f.add(_backgroundService.getAll());
      f.add(_campaignService.getAll());
      f.add(_classService.getAll());
      f.add(_featService.getAll());
      f.add(_itemService.getAll());
      f.add(_proficiencyService.getAll());
      f.add(_raceService.getAll());
      f.add(_skillService.getAll());
      f.add(_weaponService.getAll());
      final r = await Future.wait(f);
      character = r[0] ?? DndCharacter();
      archetypes = r[1];
      armors = r[2];
      backgrounds = r[3];
      campaigns = r[4];
      classes = r[5];
      feats = r[6];
      items = r[7];
      proficiencies = r[8];
      races = r[9];
      skills = r[10];
      weapons = r[11];
      // Update currents
      currentClass = classes.firstWhere((i) =>
          i.id == character.classId, orElse: () => null);
      currentArchetype = archetypes.firstWhere((i) =>
          i.id == character.archetypeId, orElse: () => null);
      currentRace = races.firstWhere((i) =>
          i.id == character.raceId, orElse: () => null);
      currentBackground = backgrounds.firstWhere((i) =>
          i.id == character.backgroundId, orElse: () => null);
      currentSkills = skills.where((s) => character.skillIds?.firstWhere(
            (j) => j == s.id, orElse: () => null) != null).toList();
      if (character.featIds != null && character.featIds.length > 0) {
        for (int i = 0; i < _currentRaceFeats.length; i++) {
          _currentRaceFeats[i] = feats.firstWhere(
              (f) => f.id == character.featIds[i], orElse: () => null);
        }
      }
      if (character.mods != null && character.mods.length > 0) {
        for (int i = 0; i < _currentRaceAttrs.length; i++) {
          _currentRaceAttrs[i] = character.mods[i];
        }
      }
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
      // Update Info
      character.backgroundId = currentBackground?.id;
      character.classId = currentClass?.id;
      character.archetypeId = currentArchetype?.id;
      character.raceId = currentRace?.id;
      character.skillIds = currentSkills != null
          ? currentSkills.map<int>((i) => i?.id).toList()
          : null;
      character.featIds = currentRaceFeats != null
          ? currentRaceFeats.map<int>((i) => i?.id).toList() : null;
      character.mods = currentRaceAttrs.where((i) => i != null).toList();
      // Create or Update
      character.id == null
          ? await _service.create(character)
          : await _service.update(character);
      setState(CoreState.saved);
    } catch (e) {
      onError(e);
    } finally {
      CoreApplication.instance.add(CoreEvent.loaded);
    }
  }

  final _service = DndCharacterService();
  final _archetypeService = DndArchetypeService();
  final _armorService = DndArmorService();
  final _backgroundService = DndBackgroundService();
  final _classService = DndClassService();
  final _campaignService = DndCampaignService();
  final _featService = DndFeatService();
  final _itemService = DndItemService();
  final _proficiencyService = DndProficiencyService();
  final _raceService = DndRaceService();
  final _skillService = DndSkillService();
  final _weaponService = DndWeaponService();
}
