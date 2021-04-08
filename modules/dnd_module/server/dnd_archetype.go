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
/// DndArchetypeModuleID
///
/// The ID for this submodule.  Used for accessing resources.
///
var DndArchetypeModuleID uint

///
/// DndArchetype
///
/// The model for this module.
///
type DndArchetype struct {
  ID                    uint                `json:"id"`
  ClassID               uint                `json:"classId"`
  Name                  string              `json:"name"`
  Desc                  string              `json:"desc" pg:"type:text"`
}

///
/// initArchetype
///
/// Initializes this sub-module, creating the module with it's ID.  Then
/// creates the database table, and sets the routes.
///
func initArchetype(router *mux.Router) {
  DndArchetypeModuleID = core_module.AddModule("Dnd Archetype Module", DndModuleID)
  core_module.AddModel((*DndArchetype)(nil));
  router.HandleFunc("/api/dnd/archetypes", getArchetypes).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/archetypes/{id}", getArchetype).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/archetypes", createArchetype).Methods("POST", "OPTIONS")
  router.HandleFunc("/api/dnd/archetypes", updateArchetype).Methods("PUT", "OPTIONS")
  router.HandleFunc("/api/dnd/archetypes/{id}", deleteArchetype).Methods("DELETE", "OPTIONS")
}

/// ----------------------------------------------------------------------------
/// ROUTES

///
/// getArchetypes
///
/// Default method for getting all of this model.
///
func getArchetypes(w http.ResponseWriter, r *http.Request) {
  core_module.InitResponse(&w)
  if (r.Method == "OPTIONS") {return}

  archetypes := []DndArchetype{}
  err := core_module.Db.Model(&archetypes).Select()

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(archetypes)
}

///
/// getArchetype
///
/// Default method for getting a single model.
///
func getArchetype(w http.ResponseWriter, r *http.Request) {
  core_module.InitResponse(&w)
  if (r.Method == "OPTIONS") {return}

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  archetype := &DndArchetype{ID: uint(idParam)}
  err := core_module.Db.Model(archetype).WherePK().Select()

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(archetype)
}

///
/// createArchetype
///
/// Default method for creating this model.
///
func createArchetype(w http.ResponseWriter, r *http.Request) {
  core_module.InitResponse(&w)
  if (r.Method == "OPTIONS") {return}

  var archetype DndArchetype
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&archetype)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&archetype).Insert()
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
/// updateArchetype
///
/// Default method for updating this model.
///
func updateArchetype(w http.ResponseWriter, r *http.Request) {
  core_module.InitResponse(&w)
  if (r.Method == "OPTIONS") {return}

  var archetype DndArchetype
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&archetype)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&archetype).WherePK().Update()
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
/// deleteArchetype
///
/// Default method for deleting this model.
///
func deleteArchetype(w http.ResponseWriter, r *http.Request) {
  core_module.InitResponse(&w)
  if (r.Method == "OPTIONS") {return}

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  archetype := &DndArchetype{ID: uint(idParam)}
  _, err := core_module.Db.Model(archetype).WherePK().Delete()

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
