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
/// DndClassesModuleID
///
/// The ID for this submodule.  Used for accessing resources.
///
var DndClassesModuleID uint

///
/// DndClass
///
/// The model for this module.
///
type DndClass struct {
  ID                    uint                `json:"id"`
  Name                  string              `json:"name"`
  Desc                  string              `json:"desc" pg:"type:text"`
  Hp                    uint8               `json:"hp"` // Per level
  SaveSTR               bool                `json:"saveStr"`
  SaveDEX               bool                `json:"saveDex"`
  SaveCON               bool                `json:"saveCon"`
  SaveINT               bool                `json:"saveInt"`
  SaveWIS               bool                `json:"saveWis"`
  SaveCHA               bool                `json:"saveCha"`
  NumOfSkills           uint8               `json:"numOfSkills"`
  SkillIDs              []uint              `json:"skillIds"`
  Feats                 []DndFeat           `json:"feats"`
  ProficiencyIDs        []uint              `json:"proficiencyIds"`
}

///
/// initArchetype
///
/// Initializes this sub-module, creating the module with it's ID.  Then
/// creates the database table, and sets the routes.
///
func initClass(router *mux.Router) {
  core_module.AddModel((*DndClass)(nil))
  core_module.InsertInitialModel(
    (*DndClass)(nil),
    &DndClass{
      Name: "Barbarian",
      Desc: "Brute, strong, uses mighty weapons with little armor.",
      Hp: 12,
      SaveSTR: true,
      SaveCON: true,
      NumOfSkills: 2,
      SkillIDs: []uint{2,4,8,11,12,18},
    },
    &DndClass{
      Name: "Bard",
      Desc: "Play lovely songs, that most adventurers find highly annoying.",
      Hp: 8,
      SaveDEX: true,
      SaveCHA: true,
      NumOfSkills: 3,
      SkillIDs: []uint{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18},
    },
    &DndClass{
      Name: "Cleric",
      Desc: "A heavy armored healer and fighter of undead.",
      Hp: 8,
      SaveWIS: true,
      SaveCHA: true,
      NumOfSkills: 2,
      SkillIDs: []uint{6,7,10,14,15},
    },
    &DndClass{
      Name: "Druid",
      Desc: "A part of nature, and animal.  A shapeshifter into animals.",
      Hp: 8,
      SaveINT: true,
      SaveWIS: true,
      NumOfSkills: 2,
      SkillIDs: []uint{2,3,7,10,11,12,15,18},
    },
    &DndClass{
      Name: "Fighter",
      Desc: "An all around skilled warrior.",
      Hp: 10,
      SaveSTR: true,
      SaveCON: true,
      NumOfSkills: 2,
      SkillIDs: []uint{1,2,4,6,7,8,12,18},
    },
    &DndClass{
      Name: "Monk",
      Desc: "One with inner peace, and spirit.",
      Hp: 8,
      SaveSTR: true,
      SaveDEX: true,
      NumOfSkills: 2,
      SkillIDs: []uint{1,4,6,7,15,17},
    },
    &DndClass{
      Name: "Paladin",
      Desc: "A knight who follows their cause above all else.",
      Hp: 10,
      SaveWIS: true,
      SaveCHA: true,
      NumOfSkills: 2,
      SkillIDs: []uint{4,7,8,10,14,15},
    },
    &DndClass{
      Name: "Ranger",
      Desc: "A hunter who is an expert at survival, and tracking.",
      Hp: 10,
      SaveSTR: true,
      SaveDEX: true,
      NumOfSkills: 3,
      SkillIDs: []uint{2,4,7,9,11,12,17,18},
    },
    &DndClass{
      Name: "Rogue",
      Desc: "A trickster, who is cunning and uses exploits to their advantage.",
      Hp: 8,
      SaveDEX: true,
      SaveINT: true,
      NumOfSkills: 4,
      SkillIDs: []uint{1,4,5,7,8,9,12,13,14,16,17},
    },
    &DndClass{
      Name: "Sorcerer",
      Desc: "A magic user, who uses charisma.",
      Hp: 6,
      SaveCON: true,
      SaveCHA: true,
      NumOfSkills: 2,
      SkillIDs: []uint{3,5,7,8,14,15},
    },
    &DndClass{
      Name: "Warlock",
      Desc: "A magic user, who attachs to an otherworldly being.",
      Hp: 8,
      SaveWIS: true,
      SaveCHA: true,
      NumOfSkills: 2,
      SkillIDs: []uint{3,5,6,8,9,11,15},
    },
    &DndClass{
      Name: "Wizard",
      Desc: "A magic user, who is highly intelligent.",
      Hp: 6,
      SaveINT: true,
      SaveWIS: true,
      NumOfSkills: 2,
      SkillIDs: []uint{3,6,7,9,10,15},
    },
  )

  router.HandleFunc("/api/dnd/classes", getClasses).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/classes/{id}", getClass).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/classes", createClass).Methods("POST", "OPTIONS")
  router.HandleFunc("/api/dnd/classes", updateClass).Methods("PUT", "OPTIONS")
  router.HandleFunc("/api/dnd/classes/{id}", deleteClass).Methods("DELETE", "OPTIONS")
}


/// ----------------------------------------------------------------------------
/// HTTP
///

///
/// getClasses
///
///
func getClasses(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var classes []DndClass

  err := core_module.Db.Model(&classes).Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(classes)
}

///
/// getClass
///
///
func getClass(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  class := &DndClass{ID: uint(idParam)}
  err := core_module.Db.Model(class).WherePK().Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }
  json.NewEncoder(w).Encode(class)
}

///
/// createClass
///
/// HTTP handler for creating a new race.
///
func createClass(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var class DndClass
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&class)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&class).Insert()
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
/// updateClass
///
///
func updateClass(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var class DndClass
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&class)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&class).WherePK().Update()
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
/// deleteClass
///
///
func deleteClass(w http.ResponseWriter, r *http.Request) {
  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  class := &DndClass{ID: uint(idParam)}
  _, err := core_module.Db.Model(class).WherePK().Delete()
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
