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
/// DndCampaignModuleID
///
/// The ID for this submodule.  Used for accessing resources.
///
var DndCampaignModuleID uint

///
/// DndCampaign
///
/// The model for this module.
///
type DndCampaign struct {
  ID                    uint                `json:"id"`
  LeaderID              uint                `json:"leaderId"`
  Name                  string              `json:"name"`
  Desc                  string              `json:"desc" pg:"type:text"`
}

///
/// initCampaign
///
/// Initializes this sub-module, creating the module with it's ID.  Then
/// creates the database table, and sets the routes.
///
func initCampaign(router *mux.Router) {
  core_module.AddModel((*DndCampaign)(nil));
  core_module.InsertInitialModel(
    (*DndCampaign)(nil),
    &DndCampaign{
      LeaderID: 1,
      Name: "Decent into Avernus",
      Desc: "Baldur's Gate",
    },
  )

  router.HandleFunc("/api/dnd/campaigns", getCampaigns).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/campaigns/{id}", getCampaign).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/campaigns", createCampaign).Methods("POST", "OPTIONS")
  router.HandleFunc("/api/dnd/campaigns", updateCampaign).Methods("PUT", "OPTIONS")
  router.HandleFunc("/api/dnd/campaigns/{id}", deleteCampaign).Methods("DELETE", "OPTIONS")
}

/// ----------------------------------------------------------------------------
/// ROUTES

///
/// getCampaigns
///
/// Default method for getting all of this model.
///
func getCampaigns(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  campaigns := []DndCampaign{}
  err := core_module.Db.Model(&campaigns).Select()

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(campaigns)
}

///
/// getCampaign
///
/// Default method for getting a single model.
///
func getCampaign(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  campaign := &DndCampaign{ID: uint(idParam)}
  err := core_module.Db.Model(campaign).WherePK().Select()

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(campaign)
}

///
/// createCampaign
///
/// Default method for creating this model.
///
func createCampaign(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var campaign DndCampaign
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&campaign)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&campaign).Insert()
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
/// updateCampaign
///
/// Default method for updating this model.
///
func updateCampaign(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var campaign DndCampaign
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&campaign)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&campaign).WherePK().Update()
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
/// deleteCampaign
///
/// Default method for deleting this model.
///
func deleteCampaign(w http.ResponseWriter, r *http.Request) {
  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  campaign := &DndCampaign{ID: uint(idParam)}
  _, err := core_module.Db.Model(campaign).WherePK().Delete()

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
