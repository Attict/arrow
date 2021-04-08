package dnd_module;

import (
  "encoding/json"
  "log"
  "net/http"
  "strconv"

  "github.com/gorilla/mux"

  "../../core_module/server"
)

///
/// DndCharacterModuleID
///
/// The ID for this submodule.  Used for accessing resources.
///
var DndCharacterModuleID uint

///
/// DndCharacter
///
/// The model for this module.
///
type DndCharacter struct {
  ID                    uint                `json:"id"`
  UserID                uint                `json:"userId"`
  CampaignID            uint                `json:"campaignId"`
  Portrait              string              `json:"portrait"`
  Public                bool                `json:"public"`

  Name                  string              `json:"name"`
  Player                string              `json:"player"`
  Alignment             string              `json:"alignment"`
  Level                 uint8               `json:"level"`
  STR                   int8                `json:"str"`
  DEX                   int8                `json:"dex"`
  CON                   int8                `json:"con"`
  INT                   int8                `json:"int"`
  WIS                   int8                `json:"wis"`
  CHA                   int8                `json:"cha"`

  // Move to using ID instead of pointers?
  RaceID                uint                `json:"raceId"`
  BackgroundID          uint                `json:"backgroundId"`
  ClassID               uint                `json:"classId"`
  ArchetypeID           uint                `json:"archetypeId"`
  SkillIDs              []uint              `json:"skillIds"`
  SpellIDs              []uint              `json:"spellIds"`
  FeatIDs               []uint              `json:"featIds"`
  ProfIDs               []uint              `json:"profIds"`
  ItemIDs               []uint              `json:"itemIds"`
  WeaponIDs             []uint              `json:"weaponIds"`
  ArmorIDs              []uint              `json:"armorIds"`

  EquipmentWeapons      []uint              `json:"equipmentWeapons"`
  EquipmentArmor        uint                `json:"equipmentArmor"`
  EquipmentShield       uint                `json:"equipmentShield"`

  // Should be text in DB
  PersonalityTraits     string              `json:"personalityTraits" pq:"type:text"`
  Ideals                string              `json:"ideals" pq:"type:text"`
  Bonds                 string              `json:"bonds" pq:"type:text"`
  Flaws                 string              `json:"flaws" pq:"type:text"`

  Organizations         string              `json:"organizations" pq:"type:text"`
  Allies                string              `json:"allies" pq:"type:text"`
  Enemies               string              `json:"enemies" pq:"type:text"`
  Backstory             string              `json:"backstory" pq:"type:text"`
  Appearance            string              `json:"appearance" pq:"type:text"`

  Age                   uint8               `json:"age"`
  Height                string              `json:"height"`
  Weight                string              `json:"weight"`
  Eyes                  string              `json:"eyes"`
  Skin                  string              `json:"skin"`
  Hair                  string              `json:"hair"`

  Mods                  []DndModifier       `json:"mods"`

  // Internal These should be moved to sheet specifically.
  Race                  *DndRace            `json:"-" pg:"-"`
  Background            *DndBackground      `json:"-" pg:"-"`
  Class                 *DndClass           `json:"-" pg:"-"`
  Armor                 *DndArmor           `json:"-" pg:"-"`
  Weapons               []*DndWeapon        `json:"-" pg:"-"`
  Proficiencies         []*DndProficiency   `json:"-" pg:"-"`
  Feats                 []*DndFeat          `json:"-" pg:"-"`
  Items                 []*DndItem          `json:"-" pg:"-"`
  //Archetype             *Archetype          `pg:"-"`
}

///
/// initCharacter
///
/// Initializes this sub-module, creating the module with it's ID.  Then
/// creates the database table, and sets the routes.
///
func initCharacter(router *mux.Router) {
  DndCharacterModuleID = core_module.AddModule("Dnd Character Module", DndModuleID)
  core_module.AddModel((*DndCharacter)(nil));
  core_module.InsertInitialModel(
    (*DndCharacter)(nil),
    &DndCharacter{
      UserID: 1,
      CampaignID: 1,
      Portrait: "/assets/images/arrick.jpg",
      Name: "Arrick",
      Player: "Eric",
      Alignment: "Neutral Good",
      Level: 20,
      STR: 10,
      DEX: 14,
      CON: 13,
      INT: 12,
      WIS: 15,
      CHA: 8,
      RaceID: 21,
      BackgroundID: 7,
      ClassID: 6,
      SkillIDs: []uint{6, 15},
      ProfIDs: nil,
      Age: 66,
      Height: "5'10\"",
      Weight: "187 lbs",
      Eyes: "Dark Brown",
      Skin: "White",
      Hair: "White",
      PersonalityTraits: "He is calm and quiet in reservations, until he has decided his direction.  Also, he tends to be a loner, because of his time spent in isolation.",
      Ideals: "Protect the innocent, especially those in need.",
      Bonds: "The elements are sacred, and must be protected from evil use.",
      Flaws: "",
      Organizations: "",
      Allies: "",
      Enemies: "",
      Backstory: "Even as a young boy, Arrick was cautious but curious.   At the age of 9, Arrick wondered through the woods outside of his <todo> town.  While he was in the woods, a pack of wolves started to surround him, and he had no choice but to run.  Running as fast as he could, he went further and further away from the places he knew, until he was lost.  After a couple years of surviving alone in the wilderness, a group of monks found him and brought Arrick to the monestary, where he trained there after.  When Arrick became of age, he bowed to his fellow monks and said goodbye, as he returned to his isolation to continue training.  Soon after he started receiving messages, from the elements.  As he listened, he knew his destiny lied in them.   From there on, he would do whatever necessary to bend the elements and become one with them.",
      Appearance: "A white beard hangs nearly a foot off of his face, with a bald head. Tattoos cover most of his body, with one in the middle of his forehead. His tattoos appear to be of the elements, and the power they contain. Typically he is found in his robe, concealing his face, and his staff on his back.",
    },
    // Baan
    &DndCharacter{
      UserID: 3,
      CampaignID: 1,
      Portrait: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTiqYEygHwPefsCbBkth5u1zcQlYZf6TJcoTFj36UOxNJjTpw7i",
      Name: "Baan Loup",
      Player: "Adam",
      Alignment: "Neutral Good",
      Level: 2,
      STR: 15,
      DEX: 13,
      CON: 12,
      INT: 10,
      WIS: 14,
      CHA: 8,
      RaceID: 21,
      BackgroundID: 14,
      ClassID: 5,
      SkillIDs: []uint{6, 8, 18},
      ProfIDs: nil,
      WeaponIDs: []uint{8},
      ArmorIDs: []uint{2},
      EquipmentWeapons: []uint{8},
      EquipmentArmor: 2,
      Age: 43,
      Height: "6'3\"",
      Weight: "225 lbs",
      Eyes: "Yellow",
      Skin: "Pale",
      Hair: "White",
      PersonalityTraits: "I don’t run from evil. Evil runs from me.  I don’t talk about the thing that torments me. I’d rather not burden others with my curse.",
      Ideals: "Sincerity. There’s no good in pretending to be something I’m not. (Neutral) I kill monsters to make the world a safer place, and to exorcise my own demons. (Good)",
      Bonds: "I have a family but have no idea where they are. One day I hope to see them again.",
      Flaws: "I feel no compassion for the dead. They’re the lucky ones.  I assume the worst in people.",
      Organizations: "",
      Allies: "",
      Enemies: "Abraxis the Sorcerer",
      Backstory: `Worked as a blacksmith making weapons and training with them in his small village. Stood alone against a troll that threatened the village.  During the fight he discovered he had some magical abilities. Eventually he slayed the Troll and word spread of his newfound abilities.

 He began to hone these newfound abilities and this caught the attention of a traveling Sorcerer named  Abraxis Hornbloom. Abraxis offered to take him under his wing and help him learn even more powerful magic. At first the training was simple learning to harness his own powers. But as the training grew more intense Baan began to sense there were Necromatic and dark undertones to what he was learning. But he was becoming more powerful so he choose to ignore it.
Abraxis wanted Baan to join him on a quest and starts to perform  a ritual to make him even more powerful.  Baan is tempted but refuses because his wife, Renfri,  is about to give birth to their first child (Visenna if a girl Fillan if a boy).

Abraxis is enraged by Baan's refusal and continues the ritual which summons a Demon.  Abraxis says "if I can't have you then  I will take your child"   The Demon pulls  the baby out of Renfri's stomach killing her. Baan goes into a blackout rage fighting Abraxis and the Demon to get the child back.  The battle spills out into the village where innocent bystanders are killed by all parties involved. Baan manages to sleigh the demon but in doing so  leaves himself open just enough for Abraxis to land a fatal blow. As he lay in the street bleeding out he sees  Abraxis pick up the child and say "Yes you will do just fine". He then stabilizes Baan  and tells him "No, No, No you don't get off that easy, you  have to live with everything your decision has caused."  The last thing Baan sees is Abraxis walking away  with his screaming baby in his arms with the village ablaze all around him.

When Baan comes to what remains of his village is in shambles. The survivors blame him for the deaths of their loved ones. Baan agrees to leave the village and begins to track down his child and the Sorcerer Abraxis.  Rumors spread of the Haunted One with hair as white as a ghost.  Who fights whatever evil stands in his path. There is great pain behind his eyes but he never talks about it. One thing is certain he is searching for someone or something and he is headed towards Baldur's Gate.


Fears:
1. Being Responsible for Friends and Family's Deaths
2. Being betrayed
3. Having to Kill his child  because he has been turned Evil
`,
      Appearance: "",
    },
  )

  router.HandleFunc("/api/dnd/characters", getCharacters).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/characters/campaign/{id}", getCharactersByCampaign).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/characters/{id}", getCharacter).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/characters", createCharacter).Methods("POST", "OPTIONS")
  router.HandleFunc("/api/dnd/characters", updateCharacter).Methods("PUT", "OPTIONS")
  router.HandleFunc("/api/dnd/characters/{id}", deleteCharacter).Methods("DELETE", "OPTIONS")
}

/// ----------------------------------------------------------------------------
/// ROUTES

///
/// getCharacters
///
/// Default method for getting all of this model.
///
func getCharacters(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  _, auth := core_module.HasPermission(&w, r, 0, core_module.CoreAccessRead)
  characters := []DndCharacter{}

  err := core_module.Db.Model(&characters).Where("user_id = ?", auth.UserID).Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(characters)
}

///
/// getCharactersByCampaign
///
/// Get's all characters belonging to a campaign.
///
/// TODO:
///     Only give specific information.
///
func getCharactersByCampaign(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  var characters []DndCharacter
  err := core_module.Db.Model(&characters).Where("campaign_id = ?", idParam).Select()

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(characters)
}

///
/// getCharacter
///
/// Default method for getting a single model.
///
func getCharacter(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)
  if r.Method == "OPTIONS" {return}

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  character := &DndCharacter{ID: uint(idParam)}
  err := core_module.Db.Model(character).WherePK().Select()

  _, auth := core_module.HasPermission(&w, r, DndCharacterModuleID, core_module.CoreAccessRead)
  if auth.UserID != 1 && !character.Public && auth.UserID != character.UserID {
    w.WriteHeader(http.StatusUnauthorized)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "You do not have access to this resource!",
    })
    log.Printf("User: %d, Resource User: %d", auth.UserID, character.UserID)
    return
  }


  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }
  json.NewEncoder(w).Encode(character)
}

///
/// createCharacter
///
/// Default method for creating this model.
///
func createCharacter(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)
  _, auth := core_module.HasPermission(&w, r, 0, core_module.CoreAccessCreate)

  var character DndCharacter
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&character)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  character.UserID = auth.UserID
  _, err = core_module.Db.Model(&character).Insert()

  if err != nil {
    w.WriteHeader(http.StatusInternalServerError)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not insert into database!",
    })
    log.Println(err)
    return
  }

  w.WriteHeader(http.StatusAccepted)
}

///
/// updateCharacter
///
/// Default method for updating this model.
///
func updateCharacter(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var character DndCharacter
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&character)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&character).WherePK().Update()
  if err != nil {
    w.WriteHeader(http.StatusInternalServerError)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not insert into database!",
    })
    log.Println(err)
    return
  }

  w.WriteHeader(http.StatusAccepted)
}

///
/// deleteCharacter
///
/// Default method for deleting this model.
///
func deleteCharacter(w http.ResponseWriter, r *http.Request) {
  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  character := &DndCharacter{ID: uint(idParam)}
  _, err := core_module.Db.Model(character).WherePK().Delete()

  if err != nil {
    w.WriteHeader(http.StatusInternalServerError)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not insert into database!",
    })
    log.Println(err)
    return
  }

  w.WriteHeader(http.StatusAccepted)
}
