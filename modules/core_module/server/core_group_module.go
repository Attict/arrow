package core_module

import (
  "strconv"
  "encoding/json"
  "net/http"

  "github.com/gorilla/mux"
)

// CoreGroupModuleID : This is the core group module ID, representing the
// module for all grouped functionality of core.  These modules will be
// able to be turned on and off through this ID.
var CoreGroupModuleID uint

// CoreGroup : The CoreGroup model for controlling user groups and the
// associated permissions
//
type CoreGroup struct {
  ID            uint             `json:"id"`
  Label         string           `json:"label"`
  Authority     uint8            `json:"authority"    sql:",nullable"`
  Permissions   []CorePermission `json:"permissions"`
}

// Init Groups
//
//
func initGroups(router *mux.Router) {
  // Module
  CoreGroupModuleID = AddModule("Core Group Module", 1)

  // Model
  model := (*CoreGroup)(nil)
  AddModel(model)
  InsertInitialModel(
    model,
    &CoreGroup{Label: "Super", Authority: 99},
    &CoreGroup{Label: "Standard", Authority: 1},
    &CoreGroup{Label: "Test", Authority: 2},
  )

  // Routes
  router.HandleFunc("/api/core/groups", getGroups).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/core/groups/{id}", getGroup).Methods("GET", "OPTIONS")
}

// Get Groups : Get's all groups
func getGroups(w http.ResponseWriter, r *http.Request) {
  InitResponse(&w)
  if r.Method == "OPTIONS" {return}

  allow, _ := HasPermission(&w, r, CoreGroupModuleID, CoreAccessRead)
  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    json.NewEncoder(w).Encode(&CoreMessage{
      Message: "Not authorized!",
    })
    return
  }

  groups := []CoreGroup{}

  err := Db.Model(&groups).Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    return
  }

  w.WriteHeader(http.StatusOK)
  json.NewEncoder(w).Encode(groups)
}

func getGroup(w http.ResponseWriter, r *http.Request) {
  InitResponse(&w)
  if r.Method == "OPTIONS" {return}

  allow, _ := HasPermission(&w, r, CoreGroupModuleID, CoreAccessRead)
  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    return
  }

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  group := &CoreGroup{ID: uint(idParam)}
  err := Db.
    Model(group).
    WherePK().
    Select()

  // This should probably be a relation, but it's not working properly
  err = Db.Model(&group.Permissions).Where("group_id = ?", group.ID).Select()
  if err != nil {
    panic(err)
    w.WriteHeader(http.StatusNotFound)
    return
  }

  w.WriteHeader(http.StatusOK)
  json.NewEncoder(w).Encode(group)
}

// Create
//
//
func createGroup(w http.ResponseWriter, r *http.Request) {
  InitResponse(&w)

  if r.Method == "OPTIONS" {return}

  allow, _ := HasPermission(&w, r, CoreGroupModuleID, CoreAccessCreate)
  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    return
  }

  var group CoreGroup
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&group)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    return
  }

  _, err = Db.Model(&group).Relation("Permissions").Insert()
  if err != nil {
    w.WriteHeader(http.StatusInternalServerError)
    return
  }

  json.NewEncoder(w).Encode(&group)
}

// Update
//
//

