library dnd_module;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:core_module/core_module.dart';

part 'blocs/dnd_archetype_bloc.dart';
part 'blocs/dnd_archetypes_bloc.dart';
part 'blocs/dnd_armor_bloc.dart';
part 'blocs/dnd_armors_bloc.dart';
part 'blocs/dnd_background_bloc.dart';
part 'blocs/dnd_backgrounds_bloc.dart';
part 'blocs/dnd_campaign_bloc.dart';
part 'blocs/dnd_campaigns_bloc.dart';
part 'blocs/dnd_character_bloc.dart';
part 'blocs/dnd_characters_bloc.dart';
part 'blocs/dnd_class_bloc.dart';
part 'blocs/dnd_classes_bloc.dart';
part 'blocs/dnd_feat_bloc.dart';
part 'blocs/dnd_feats_bloc.dart';
part 'blocs/dnd_item_bloc.dart';
part 'blocs/dnd_items_bloc.dart';
part 'blocs/dnd_proficiency_bloc.dart';
part 'blocs/dnd_proficiencies_bloc.dart';
part 'blocs/dnd_race_bloc.dart';
part 'blocs/dnd_races_bloc.dart';
part 'blocs/dnd_spell_bloc.dart';
part 'blocs/dnd_spells_bloc.dart';
part 'blocs/dnd_status_bloc.dart';
part 'blocs/dnd_statuses_bloc.dart';
part 'blocs/dnd_weapon_bloc.dart';
part 'blocs/dnd_weapons_bloc.dart';

part 'models/dnd_armor.dart';
part 'models/dnd_archetype.dart';
part 'models/dnd_background.dart';
part 'models/dnd_bonus.dart';
part 'models/dnd_campaign.dart';
part 'models/dnd_character.dart';
part 'models/dnd_class.dart';
part 'models/dnd_feat.dart';
part 'models/dnd_item.dart';
part 'models/dnd_modifier.dart';
part 'models/dnd_proficiency.dart';
part 'models/dnd_race.dart';
part 'models/dnd_skill.dart';
part 'models/dnd_spell.dart';
part 'models/dnd_status.dart';
part 'models/dnd_weapon.dart';

part 'services/dnd_archetype_service.dart';
part 'services/dnd_armor_service.dart';
part 'services/dnd_background_service.dart';
part 'services/dnd_campaign_service.dart';
part 'services/dnd_character_service.dart';
part 'services/dnd_class_service.dart';
part 'services/dnd_feat_service.dart';
part 'services/dnd_item_service.dart';
part 'services/dnd_proficiency_service.dart';
part 'services/dnd_race_service.dart';
part 'services/dnd_skill_service.dart';
part 'services/dnd_spell_service.dart';
part 'services/dnd_status_service.dart';
part 'services/dnd_weapon_service.dart';

Future<Null> dndUpload(String data) async {
  final response = await http.post(
      '${CoreApplication.instance.config.api}/dnd/upload', body: data);
  if (response.statusCode != 202) {
    throw CoreException.fromResponse(response);
  }
}
