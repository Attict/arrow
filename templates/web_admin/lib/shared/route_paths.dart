import 'package:angular_router/angular_router.dart';

const idParam = 'id';

///
/// RoutePaths
///
/// The defined routes for the application used in the URL.
///
class RoutePaths {
  static final coreGroups = RoutePath(path: 'groups');
  static final coreModules = RoutePath(path: 'modules');
  static final coreUser = RoutePath(path: 'users/:$idParam');
  static final coreUsers = RoutePath(path: 'users');

  static final dnd = RoutePath(path: 'dnd');
  static final dndArchetype = RoutePath(path: 'archetypes/:$idParam');
  static final dndArchetypes = RoutePath(path: 'archetypes');
  static final dndArmor = RoutePath(path: 'armors/:$idParam');
  static final dndArmors = RoutePath(path: 'armors');
  static final dndBackground = RoutePath(path: 'backgrounds/:$idParam');
  static final dndBackgrounds = RoutePath(path: 'backgrounds');
  static final dndCampaign = RoutePath(path: 'campaigns/:$idParam');
  static final dndCampaigns = RoutePath(path: 'campaigns');
  static final dndCharacter = RoutePath(path: 'characters/:$idParam');
  static final dndCharacters = RoutePath(path: 'characters');
  static final dndClass = RoutePath(path: 'classes/:$idParam');
  static final dndClasses = RoutePath(path: 'classes');
  static final dndFeat = RoutePath(path: 'feats/:$idParam');
  static final dndFeats = RoutePath(path: 'feats');
  static final dndItem = RoutePath(path: 'items/:$idParam');
  static final dndItems = RoutePath(path: 'items');
  static final dndProficiency = RoutePath(path: 'proficiencies/:$idParam');
  static final dndProficiencies = RoutePath(path: 'proficiencies');
  static final dndRace = RoutePath(path: 'races/:$idParam');
  static final dndRaces = RoutePath(path: 'races');
  static final dndSpell = RoutePath(path: 'spells/:$idParam');
  static final dndSpells = RoutePath(path: 'spells');
  static final dndUpload = RoutePath(path: 'upload');
  static final dndWeapon = RoutePath(path: 'weapons/:$idParam');
  static final dndWeapons = RoutePath(path: 'weapons');

  static final tabletop = RoutePath(path: 'tabletop');
  static final tabletopMap = RoutePath(path: 'tabletop/map');
}

int getId(Map<String, String> parameters) {
  final id = parameters[idParam];
  return id == null ? null : int.tryParse(id);
}
