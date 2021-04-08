package dnd_module;

import (
  "encoding/json"
  "log"
  "net/http"
  "strconv"

  "github.com/gorilla/mux"

  "../../core_module/server"
)

const (
  SpellShape_Line = 1
  SpellShape_Cone = 2
  SpellShape_Sphere = 3

  SpellType_Fire = 1
  SpellType_Lightning = 2

  SpellSave_STR = 1
  SpellSave_DEX = 2
  SpellSave_CON = 3
  SpellSave_INT = 4
  SpellSave_WIS = 5
  SpellSave_CHA = 6
)

type DndSpell struct {
  ID                    uint                `json:"id"`
  Name                  string              `json:"name"`
  Desc                  string              `json:"desc" pg:"type:text"`
  Level                 uint8               `json:"level"`
  Range                 uint16              `json:"range"`
  Shape                 uint8               `json:"shape"`
  Type                  uint8               `json:"type"`
  Save                  uint8               `json:"save"`
}

func initSpell(router *mux.Router) {
  core_module.AddModel((*DndSpell)(nil));
  core_module.InsertInitialModel(
    (*DndSpell)(nil),
    &DndSpell{
      Name: "Burning Hands",
      Desc: "Deals 1d6 per level in damage in a cone.",
      Level: 1,
      Range: 40,
      Shape: SpellShape_Cone,
      Type: SpellType_Fire,
      Save: SpellSave_DEX,
    },
    &DndSpell{
      Name: "Thunderclap",
      Desc: "Deals 3d6 damage in a sphere.",
      Level: 1,
      Range: 50,
      Shape: SpellShape_Sphere,
      Type: SpellType_Lightning,
      Save: SpellSave_DEX,
    },
  )

  router.HandleFunc("/api/dnd/spells", getSpells).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/spells/{id}", getSpell).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/spells", createSpell).Methods("POST", "OPTIONS")
  router.HandleFunc("/api/dnd/spells", updateSpell).Methods("PUT", "OPTIONS")
  router.HandleFunc("/api/dnd/spells/{id}", deleteSpell).Methods("DELETE", "OPTIONS")
}

/// ----------------------------------------------------------------------------
/// HTTP
///

func getSpells(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var spells []DndSpell

  err := core_module.Db.Model(&spells).Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(spells)
}

///
/// getSpell
///
///
func getSpell(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  spell := &DndSpell{ID: uint(idParam)}
  err := core_module.Db.Model(spell).WherePK().Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }
  json.NewEncoder(w).Encode(spell)
}

///
/// createSpell
///
/// HTTP handler for creating a new spell.
///
func createSpell(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var spell DndSpell
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&spell)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&spell).Insert()
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
/// updateSpell
///
///
func updateSpell(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var spell DndSpell
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&spell)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&spell).WherePK().Update()
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
/// deleteSpell
///
///
func deleteSpell(w http.ResponseWriter, r *http.Request) {
  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  spell := &DndSpell{ID: uint(idParam)}
  _, err := core_module.Db.Model(spell).WherePK().Delete()
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
