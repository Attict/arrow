part of dnd_module;

class DndItem {
  static const int typeGeneral = 1;
  static const int typeWeapon = 2;
  static const int typeArmor = 3;
  static const int typeShield = 4;
  static const int typePotion = 5;
  static const int typeScroll = 6;
  static const int typeAmmunition = 7;

  static Map<int, String> getTypeValues() => {
    typeGeneral: 'General',
    typeWeapon: 'Weapon',
    typeArmor: 'Armor',
    typeShield: 'Shield',
    typePotion: 'Potion',
    typeScroll: 'Scroll',
    typeAmmunition: 'Ammunition',
  };

  int id;
  String name;
  String desc;
  int type;
  double price;
  double weight;

  DndItem({
    this.id,
    this.name,
    this.desc,
    this.type,
    this.price,
    this.weight,
  });

  factory DndItem.fromMap(Map<String, dynamic> data) => DndItem(
    id: data['id'],
    name: data['name'],
    desc: data['desc'],
    type: data['type'],
    price: data['price'],
    weight: data['weight'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'desc': desc,
    'type': type,
    'price': price,
    'weight': weight,
  };
}
