part of dnd_module;

class DndCampaignService extends CoreService<DndCampaign> {
  String route = '${CoreApplication.instance.config.api}/dnd/campaigns';

  DndCampaign createObject(Map<String, dynamic> data)
      => DndCampaign.fromMap(data);
}
