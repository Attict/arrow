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
  ProficiencyType_Language = 1
  ProficiencyType_Armor = 2
  ProficiencyType_Weapon = 3
)

type DndProficiency struct {
  ID                    uint                `json:"id"`
  Name                  string              `json:"name"`
  Desc                  string              `json:"desc" pg:"type:text"`
  Type                  uint8               `json:"type"`
  Mods                  []DndModifier       `json:"mods"`
}

func initProficiency(router *mux.Router) {
  core_module.AddModel((*DndProficiency)(nil));
  core_module.InsertInitialModel(
    (*DndProficiency)(nil),
    &DndProficiency{
      Name: "Common Language",
      Desc: "The most common language spoken.",
      Type: ProficiencyType_Language,
    },
    &DndProficiency{
      Name: "Dwarvish Language",
      Desc: "The language of dwarves",
      Type: ProficiencyType_Language,
    },
  )

  router.HandleFunc("/api/dnd/proficiencies", getProficiencies).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/proficiencies/type/{id}", getProficienciesByType).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/proficiencies/{id}", getProficiency).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/proficiencies", createProficiency).Methods("POST", "OPTIONS")
  router.HandleFunc("/api/dnd/proficiencies", updateProficiency).Methods("PUT", "OPTIONS")
  router.HandleFunc("/api/dnd/proficiencies/{id}", deleteProficiency).Methods("DELETE", "OPTIONS")
}

/// ----------------------------------------------------------------------------
/// HTTP
///

func getProficiencies(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var proficiencies []DndProficiency

  err := core_module.Db.Model(&proficiencies).Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(proficiencies)
}

///
/// getProficienciesByType
///
///
func getProficienciesByType(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)
  proficiencies := []DndProficiency{}

  err := core_module.Db.Model(&proficiencies).Where("type = ?", idParam).Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(proficiencies)
}

///
/// getProficiency
///
///
func getProficiency(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  proficiency := &DndProficiency{ID: uint(idParam)}
  err := core_module.Db.Model(proficiency).WherePK().Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }
  json.NewEncoder(w).Encode(proficiency)
}

///
/// createProficiency
///
/// HTTP handler for creating a new proficiency.
///
func createProficiency(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var proficiency DndProficiency
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&proficiency)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&proficiency).Insert()
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
/// updateProficiency
///
///
func updateProficiency(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var proficiency DndProficiency
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&proficiency)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&proficiency).WherePK().Update()
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
/// deleteProficiency
///
///
func deleteProficiency(w http.ResponseWriter, r *http.Request) {
  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  proficiency := &DndProficiency{ID: uint(idParam)}
  _, err := core_module.Db.Model(proficiency).WherePK().Delete()
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
