package dnd_module

import (
  "encoding/json"
  "log"
  "net/http"
  "strconv"

  "github.com/gorilla/mux"

  "../../core_module/server"
)

///
/// DndBackgroundModuleID
///
/// The ID for this submodule.  Used for accessing resources.
///
var DndBackgroundModuleID uint

///
/// DndBackground
///
/// The model for this module.
///
type DndBackground struct {
  ID                    uint                `json:"id"`
  Name                  string              `json:"name"`
  Desc                  string              `json:"desc" pq:"type:text"`
  SkillIDs              []uint              `json:"skillIds"`
}

///
/// initBackground
///
/// Initializes this sub-module, creating the module with it's ID.  Then
/// creates the database table, and sets the routes.
///
func initBackground(router *mux.Router) {
  DndBackgroundModuleID = core_module.AddModule("Dnd Background Module", DndModuleID)
  core_module.AddModel((*DndBackground)(nil))
  router.HandleFunc("/api/dnd/backgrounds", getBackgrounds).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/backgrounds/{id}", getBackground).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/backgrounds", createBackground).Methods("POST", "OPTIONS")
  router.HandleFunc("/api/dnd/backgrounds", updateBackground).Methods("PUT", "OPTIONS")
  router.HandleFunc("/api/dnd/backgrounds/{id}", deleteBackground).Methods("DELETE", "OPTIONS")
}

/// ----------------------------------------------------------------------------
/// HTTP
///

///
/// getBackgrounds
///
/// Default method for getting all of this model.
///
func getBackgrounds(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  backgrounds := []DndBackground{}

  err := core_module.Db.Model(&backgrounds).Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(backgrounds)
}

///
/// getBackground
///
///
func getBackground(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  background := &DndBackground{ID: uint(idParam)}
  err := core_module.Db.Model(background).WherePK().Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }
  json.NewEncoder(w).Encode(background)
}

///
/// createBackground
///
/// HTTP handler for creating a new race.
///
func createBackground(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var background DndBackground
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&background)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&background).Insert()
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
/// updateBackground
///
///
func updateBackground(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var background DndBackground
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&background)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&background).WherePK().Update()
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
/// deleteBackground
///
///
func deleteBackground(w http.ResponseWriter, r *http.Request) {
  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  background := &DndBackground{ID: uint(idParam)}
  _, err := core_module.Db.Model(background).WherePK().Delete()
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
