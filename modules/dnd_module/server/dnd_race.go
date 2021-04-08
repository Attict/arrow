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
/// DndRaceModuleID
///
/// The ID for this submodule.  Used for accessing resources.
///
var DndRaceModuleID uint

///
/// DndRace
///
/// The model for this module.
///
type DndRace struct {
  ID                    uint                `json:"id"`
  Name                  string              `json:"name"`
  Desc                  string              `json:"desc" pg:"type:text"`
  Speed                 uint8               `json:"speed"`
  STR                   int8                `json:"str"`
  DEX                   int8                `json:"dex"`
  CON                   int8                `json:"con"`
  INT                   int8                `json:"int"`
  WIS                   int8                `json:"wis"`
  CHA                   int8                `json:"cha"`
  AttrPoints            uint8               `json:"attrPoints"` // Points for any attr
  FeatPoints            uint8               `json:"featPoints"` // Points for any feat
  LangPoints            uint8               `json:"langPoints"`

  Feats                 []DndFeat           `json:"feats"`
  ProficiencyIDs        []uint              `json:"proficiencyIds"`

  DescAge               string              `json:"descAge"`
  DescAlignment         string              `json:"descAlignment"`
  DescSize              string              `json:"descSize"`
}

///
/// initRace
///
/// Initializes this sub-module, creating the module with it's ID.  Then
/// creates the database table, and sets the routes.
///
func initRace(router *mux.Router) {
  core_module.AddModel((*DndRace)(nil))
  router.HandleFunc("/api/dnd/races", getRaces).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/races/{id}", getRace).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/races", createRace).Methods("POST", "OPTIONS")
  router.HandleFunc("/api/dnd/races", updateRace).Methods("PUT", "OPTIONS")
  router.HandleFunc("/api/dnd/races/{id}", deleteRace).Methods("DELETE", "OPTIONS")
  router.HandleFunc("/api/dnd/races/import", createRaces).Methods("POST", "OPTIONS")
}

/// ----------------------------------------------------------------------------
/// ROUTES

///
/// getRaces
///
/// Default method for getting all of this model.
///
func getRaces(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  races := []DndRace{}
  err := core_module.Db.Model(&races).Select()

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(races)
}

///
/// getRace
///
/// Default method for getting a single model.
///
func getRace(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  race := &DndRace{ID: uint(idParam)}
  err := core_module.Db.Model(race).WherePK().Select()

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }
  json.NewEncoder(w).Encode(race)
}

///
/// createRace
///
/// Default method for creating this model.
///
func createRace(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var race DndRace
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&race)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&race).Insert()
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
/// updateRace
///
/// Default method for updating this model.
///
func updateRace(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var race DndRace
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&race)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&race).WherePK().Update()
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
/// deleteRace
///
/// Default method for deleting this model.
///
func deleteRace(w http.ResponseWriter, r *http.Request) {
  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  race := &DndRace{ID: uint(idParam)}
  _, err := core_module.Db.Model(race).WherePK().Delete()
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

func createRaces(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var races []DndRace
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&races)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&races).Insert()
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
