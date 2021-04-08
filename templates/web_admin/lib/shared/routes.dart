import 'package:angular_router/angular_router.dart';

import 'package:web_admin/shared/route_paths.dart';
export 'package:web_admin/shared/route_paths.dart';

/// CORE MODULE
import 'package:web_admin/modules/core_module/groups_component/groups_component.template.dart' as core_groups_template;
import 'package:web_admin/modules/core_module/modules_component/modules_component.template.dart' as core_modules_template;
import 'package:web_admin/modules/core_module/user_component/user_component.template.dart' as core_user_template;
import 'package:web_admin/modules/core_module/users_component/users_component.template.dart' as core_users_template;

/// DND MODULE
import 'package:web_admin/modules/dnd_module/dnd_component/dnd_component.template.dart' as dnd_template;
import 'package:web_admin/modules/dnd_module/archetype_component/archetype_component.template.dart' as dnd_archetype_template;
import 'package:web_admin/modules/dnd_module/archetypes_component/archetypes_component.template.dart' as dnd_archetypes_template;
import 'package:web_admin/modules/dnd_module/armor_component/armor_component.template.dart' as dnd_armor_template;
import 'package:web_admin/modules/dnd_module/armors_component/armors_component.template.dart' as dnd_armors_template;
import 'package:web_admin/modules/dnd_module/background_component/background_component.template.dart' as dnd_background_template;
import 'package:web_admin/modules/dnd_module/backgrounds_component/backgrounds_component.template.dart' as dnd_backgrounds_template;
import 'package:web_admin/modules/dnd_module/campaign_component/campaign_component.template.dart' as dnd_campaign_template;
import 'package:web_admin/modules/dnd_module/campaigns_component/campaigns_component.template.dart' as dnd_campaigns_template;
import 'package:web_admin/modules/dnd_module/character_component/character_component.template.dart' as dnd_character_template;
import 'package:web_admin/modules/dnd_module/characters_component/characters_component.template.dart' as dnd_characters_template;
import 'package:web_admin/modules/dnd_module/class_component/class_component.template.dart' as dnd_class_template;
import 'package:web_admin/modules/dnd_module/classes_component/classes_component.template.dart' as dnd_classes_template;
import 'package:web_admin/modules/dnd_module/feat_component/feat_component.template.dart' as dnd_feat_template;
import 'package:web_admin/modules/dnd_module/feats_component/feats_component.template.dart' as dnd_feats_template;
import 'package:web_admin/modules/dnd_module/item_component/item_component.template.dart' as dnd_item_template;
import 'package:web_admin/modules/dnd_module/items_component/items_component.template.dart' as dnd_items_template;
import 'package:web_admin/modules/dnd_module/proficiency_component/proficiency_component.template.dart' as dnd_proficiency_template;
import 'package:web_admin/modules/dnd_module/proficiencies_component/proficiencies_component.template.dart' as dnd_proficiencies_template;
import 'package:web_admin/modules/dnd_module/race_component/race_component.template.dart' as dnd_race_template;
import 'package:web_admin/modules/dnd_module/races_component/races_component.template.dart' as dnd_races_template;
import 'package:web_admin/modules/dnd_module/spell_component/spell_component.template.dart' as dnd_spell_template;
import 'package:web_admin/modules/dnd_module/spells_component/spells_component.template.dart' as dnd_spells_template;
import 'package:web_admin/modules/dnd_module/upload_component/upload_component.template.dart' as dnd_upload_template;
import 'package:web_admin/modules/dnd_module/weapon_component/weapon_component.template.dart' as dnd_weapon_template;
import 'package:web_admin/modules/dnd_module/weapons_component/weapons_component.template.dart' as dnd_weapons_template;

///
/// Tabletop
///
import 'package:web_admin/modules/tabletop_module/map_component/map_component.template.dart' as tabletop_map_template;

///
/// Routes
///
/// *In alphabetical order.*
///
class Routes {
  ///
  /// CORE MODULE
  ///
  static final coreGroups = RouteDefinition(
    routePath: RoutePaths.coreGroups,
    component: core_groups_template.GroupsComponentNgFactory,
  );
  static final coreModules = RouteDefinition(
    routePath: RoutePaths.coreModules,
    component: core_modules_template.ModulesComponentNgFactory,
  );
  static final coreUser = RouteDefinition(
    routePath: RoutePaths.coreUser,
    component: core_user_template.UserComponentNgFactory,
  );
  static final coreUsers = RouteDefinition(
    routePath: RoutePaths.coreUsers,
    component: core_users_template.UsersComponentNgFactory,
  );

  ///
  /// DND MODULE
  ///
  static final dnd = RouteDefinition(
    routePath: RoutePaths.dnd,
    component: dnd_template.DndComponentNgFactory,
  );
  static final dndArchetype = RouteDefinition(
    routePath: RoutePaths.dndArchetype,
    component: dnd_archetype_template.ArchetypeComponentNgFactory,
  );
  static final dndArchetypes = RouteDefinition(
    routePath: RoutePaths.dndArchetypes,
    component: dnd_archetypes_template.ArchetypesComponentNgFactory,
  );
  static final dndArmor = RouteDefinition(
    routePath: RoutePaths.dndArmor,
    component: dnd_armor_template.ArmorComponentNgFactory,
  );
  static final dndArmors = RouteDefinition(
    routePath: RoutePaths.dndArmors,
    component: dnd_armors_template.ArmorsComponentNgFactory,
  );
  static final dndBackground = RouteDefinition(
    routePath: RoutePaths.dndBackground,
    component: dnd_background_template.BackgroundComponentNgFactory,
  );
  static final dndBackgrounds = RouteDefinition(
    routePath: RoutePaths.dndBackgrounds,
    component: dnd_backgrounds_template.BackgroundsComponentNgFactory,
  );
  static final dndCampaign = RouteDefinition(
    routePath: RoutePaths.dndCampaign,
    component: dnd_campaign_template.CampaignComponentNgFactory,
  );
  static final dndCampaigns = RouteDefinition(
    routePath: RoutePaths.dndCampaigns,
    component: dnd_campaigns_template.CampaignsComponentNgFactory,
  );
  static final dndCharacter = RouteDefinition(
    routePath: RoutePaths.dndCharacter,
    component: dnd_character_template.CharacterComponentNgFactory,
  );
  static final dndCharacters = RouteDefinition(
    routePath: RoutePaths.dndCharacters,
    component: dnd_characters_template.CharactersComponentNgFactory,
  );
  static final dndClass = RouteDefinition(
    routePath: RoutePaths.dndClass,
    component: dnd_class_template.ClassComponentNgFactory,
  );
  static final dndClasses = RouteDefinition(
    routePath: RoutePaths.dndClasses,
    component: dnd_classes_template.ClassesComponentNgFactory,
  );
  static final dndFeat = RouteDefinition(
    routePath: RoutePaths.dndFeat,
    component: dnd_feat_template.FeatComponentNgFactory,
  );
  static final dndFeats = RouteDefinition(
    routePath: RoutePaths.dndFeats,
    component: dnd_feats_template.FeatsComponentNgFactory,
  );
  static final dndItem = RouteDefinition(
    routePath: RoutePaths.dndItem,
    component: dnd_item_template.ItemComponentNgFactory,
  );
  static final dndItems = RouteDefinition(
    routePath: RoutePaths.dndItems,
    component: dnd_items_template.ItemsComponentNgFactory,
  );
  static final dndProficiency = RouteDefinition(
    routePath: RoutePaths.dndProficiency,
    component: dnd_proficiency_template.ProficiencyComponentNgFactory,
  );
  static final dndProficiencies = RouteDefinition(
    routePath: RoutePaths.dndProficiencies,
    component: dnd_proficiencies_template.ProficienciesComponentNgFactory,
  );
  static final dndRace = RouteDefinition(
    routePath: RoutePaths.dndRace,
    component: dnd_race_template.RaceComponentNgFactory,
  );
  static final dndRaces = RouteDefinition(
    routePath: RoutePaths.dndRaces,
    component: dnd_races_template.RacesComponentNgFactory,
  );
  static final dndSpell = RouteDefinition(
    routePath: RoutePaths.dndSpell,
    component: dnd_spell_template.SpellComponentNgFactory,
  );
  static final dndSpells = RouteDefinition(
    routePath: RoutePaths.dndSpells,
    component: dnd_spells_template.SpellsComponentNgFactory,
  );
  static final dndUpload = RouteDefinition(
    routePath: RoutePaths.dndUpload,
    component: dnd_upload_template.UploadComponentNgFactory,
  );
  static final dndWeapon = RouteDefinition(
    routePath: RoutePaths.dndWeapon,
    component: dnd_weapon_template.WeaponComponentNgFactory,
  );
  static final dndWeapons = RouteDefinition(
    routePath: RoutePaths.dndWeapons,
    component: dnd_weapons_template.WeaponsComponentNgFactory,
  );

  ///
  /// Tabletop
  ///
  static final tabletopMap = RouteDefinition(
    routePath: RoutePaths.tabletopMap,
    component: tabletop_map_template.MapComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    coreGroups,
    coreModules,
    coreUser,
    coreUsers,

    ///
    /// DND
    ///
    dnd,
    dndArchetype,
    dndArchetypes,
    dndArmor,
    dndArmors,
    dndBackground,
    dndBackgrounds,
    dndCampaign,
    dndCampaigns,
    dndCharacter,
    dndCharacters,
    dndClass,
    dndClasses,
    dndFeat,
    dndFeats,
    dndItem,
    dndItems,
    dndProficiency,
    dndProficiencies,
    dndRace,
    dndRaces,
    dndSpell,
    dndSpells,
    dndUpload,
    dndWeapon,
    dndWeapons,

    ///
    /// Tabletop
    ///
    tabletopMap,

    ///
    /// Default
    ///
    RouteDefinition.redirect(
      path: '',
      redirectTo: RoutePaths.dndClasses.toUrl(),
    ),
  ];
}
