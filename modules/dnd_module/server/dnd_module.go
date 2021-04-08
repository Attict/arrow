package dnd_module

import (
  "encoding/json"
  "log"
  "net/http"

  "github.com/gorilla/mux"

  "../../core_module/server"
)

var DndModuleID uint

///
/// Init
///
/// Initializes this module, creating the sub module with their ID.
///
/// Creates each sub-module's ID, DB Table, and Routes.
///
func Init(router *mux.Router) {
  DndModuleID = core_module.AddModule("Dnd Module", 0)

  initArchetype(router)
  initArmor(router)
  initBackground(router)
  initCampaign(router)
  initCharacter(router)
  initClass(router)
  initFeat(router)
  initItem(router)
  initProficiency(router)
  initRace(router)
  initSpell(router)
  initStatus(router)
  initWeapon(router)

  router.HandleFunc("/api/dnd/skills", getSkills).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/character-sheet", characterSheet)
  router.HandleFunc("/api/dnd/upload", upload).Methods("POST")
}

func getSkills(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)
  json.NewEncoder(w).Encode(skills)
}

type Archetype struct {
  ID                    uint                `json:"id"`
  ClassID               uint                `json:"class"`
  Name                  string              `json:"name"`
  Desc                  string              `json:"desc"`
}
type Spell struct {
  ID                    uint                `json:"id"`
  Name                  string              `json:"name"`
  Desc                  string              `json:"desc"`
  SpellLvl              uint8               `json:"spellLvl"`
  ReqLvl                uint8               `json:"reqLvl"`
}

const (
  Type_STR          = 1
  Type_DEX          = 2
  Type_CON          = 3
  Type_INT          = 4
  Type_WIS          = 5
  Type_CHA          = 6
  Type_HP           = 7
  Type_AC           = 8
  Type_SPEED        = 9
  Type_INIT         = 10
  Type_FEAT         = 11
  Type_HIT          = 12
  Type_DAMAGE       = 13
  Type_MINRANGE     = 14
  Type_MAXRANGE     = 15

  From_RACE         = 1
  From_CLASS        = 2
  From_BACKGROUND   = 3
)

const (
  ModType_ATTR = 1
  ModType_SKILL = 2
  ModType_SPELL = 3
)

type DndModifier struct {
  Type                  uint8               `json:"type"`
  Subtype               uint8               `json:"subtype"`
  Value                 int16               `json:"value"`
}


type DndUpload struct {
  Archetypes            []*DndArchetype     `json:"archetypes"`
  Armors                []*DndArmor         `json:"armors"`
  Backgrounds           []*DndBackground    `json:"backgrounds"`
  Classes               []*DndClass         `json:"classes"`
  Feats                 []*DndFeat          `json:"feats"`
  Items                 []*DndItem          `json:"items"`
  Proficiencies         []*DndProficiency   `json:"proficiencies"`
  Races                 []*DndRace          `json:"races"`
  Spells                []*DndSpell         `json:"spells"`
  Weapons               []*DndWeapon        `json:"weapons"`
}

func upload(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var upload DndUpload
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&upload)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  if upload.Archetypes != nil && len (upload.Archetypes) > 0 {
    _, err = core_module.Db.Model(&upload.Archetypes).Insert()
  }
  if upload.Armors != nil && len (upload.Armors) > 0 {
    _, err = core_module.Db.Model(&upload.Armors).Insert()
  }
  if upload.Backgrounds != nil && len (upload.Backgrounds) > 0 {
    _, err = core_module.Db.Model(&upload.Backgrounds).Insert()
  }
  if upload.Classes != nil && len (upload.Classes) > 0 {
    _, err = core_module.Db.Model(&upload.Classes).Insert()
  }
  if upload.Feats != nil && len (upload.Feats) > 0 {
    _, err = core_module.Db.Model(&upload.Feats).Insert()
  }
  if upload.Items != nil && len (upload.Items) > 0 {
    _, err = core_module.Db.Model(&upload.Items).Insert()
  }
  if upload.Proficiencies != nil && len (upload.Proficiencies) > 0 {
    _, err = core_module.Db.Model(&upload.Proficiencies).Insert()
  }
  if upload.Races != nil && len (upload.Races) > 0 {
    _, err = core_module.Db.Model(&upload.Races).Insert()
  }
  if upload.Spells != nil && len (upload.Spells) > 0 {
    _, err = core_module.Db.Model(&upload.Spells).Insert()
  }
  if upload.Weapons != nil && len(upload.Weapons) > 0 {
    _, err = core_module.Db.Model(&upload.Weapons).Insert()
  }

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

