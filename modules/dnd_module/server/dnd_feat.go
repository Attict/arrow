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
  FeatType_Select = 1
  FeatType_Background = 2
  FeatType_Class = 3
  FeatType_Race = 4
)

type DndFeat struct {
  ID                    uint                `json:"id"`
  Name                  string              `json:"name"`
  Desc                  string              `json:"desc"`
  Type                  uint8               `json:"type"`
  Level                 uint8               `json:"level"`
  Mods                  []DndModifier       `json:"mods"`
}

func initFeat(router *mux.Router) {
  core_module.AddModel((*DndFeat)(nil));
  router.HandleFunc("/api/dnd/feats", getFeats).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/feats/type/{id}", getFeatsByType).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/feats/{id}", getFeat).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/feats", createFeat).Methods("POST", "OPTIONS")
  router.HandleFunc("/api/dnd/feats", updateFeat).Methods("PUT", "OPTIONS")
  router.HandleFunc("/api/dnd/feats/{id}", deleteFeat).Methods("DELETE", "OPTIONS")
}

/// ----------------------------------------------------------------------------
/// ROUTES

///
/// getFeats
///
/// Default method for getting all of this model.
///
func getFeats(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  feats := []DndFeat{}
  err := core_module.Db.Model(&feats).Select()

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(feats)
}

func getFeatsByType(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  feats := []DndFeat{}

  err := core_module.Db.Model(&feats).Where("type = ?", idParam).Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(feats)
}

///
/// getFeat
///
///
func getFeat(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  feat := &DndFeat{ID: uint(idParam)}
  err := core_module.Db.Model(feat).WherePK().Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }
  json.NewEncoder(w).Encode(feat)
}

///
/// createFeat
///
/// HTTP handler for creating a new feat.
///
func createFeat(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var feat DndFeat
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&feat)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&feat).Insert()
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
/// updateFeat
///
///
func updateFeat(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var feat DndFeat
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&feat)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&feat).WherePK().Update()
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
/// deleteFeat
///
///
func deleteFeat(w http.ResponseWriter, r *http.Request) {
  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  feat := &DndFeat{ID: uint(idParam)}
  _, err := core_module.Db.Model(feat).WherePK().Delete()
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

