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
/// DndArmorModuleID
///
/// The ID for this submodule.  Used for accessing resources.
///
var DndArmorModuleID uint

///
/// CONST
///
/// Constants for [ArmorType] and [ArmorSlot] values.
///
const (
  ArmorType_Light = 1
  ArmorType_Medium = 2
  ArmorType_Heavy = 3

  ArmorSlot_Armor = 1
  ArmorSlot_Shield = 2
)

///
/// DndArmor
///
/// The model for this module.
///
type DndArmor struct {
  ID                    uint                `json:"id"`
  Item                  DndItem             `json:"item"`
  Type                  uint8               `json:"type"`
  Slot                  uint8               `json:"slot"`
  AC                    int8                `json:"ac"`
  ReqSTR                uint8               `json:"reqStr"`
  DEXMod                bool                `json:"dexMod"`
  DEXModMax             uint8               `json:"dexModMax"`
  DAStealth             bool                `json:"daStealth"`
}

///
/// initArmor
///
/// Initializes this sub-module, creating the module with it's ID.  Then
/// creates the database table, and sets the routes.
///
func initArmor(router *mux.Router) {
  DndArmorModuleID = core_module.AddModule("Dnd Armor Module", DndModuleID)
  core_module.AddModel((*DndArmor)(nil));
  router.HandleFunc("/api/dnd/armors", getArmors).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/armors/{id}", getArmor).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/armors", createArmor).Methods("POST", "OPTIONS")
  router.HandleFunc("/api/dnd/armors", updateArmor).Methods("PUT", "OPTIONS")
  router.HandleFunc("/api/dnd/armors/{id}", deleteArmor).Methods("DELETE", "OPTIONS")
}

/// ----------------------------------------------------------------------------
/// ROUTES

///
/// getArmors
///
/// Default method for getting all of this model.
///
func getArmors(w http.ResponseWriter, r *http.Request) {
  core_module.InitResponse(&w)
  if (r.Method == "OPTIONS") {return}

  armors := []DndArmor{}
  err := core_module.Db.Model(&armors).Select()

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(armors)
}

///
/// getArmor
///
/// Default method for getting a single model.
///
func getArmor(w http.ResponseWriter, r *http.Request) {
  core_module.InitResponse(&w)
  if (r.Method == "OPTIONS") {return}

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  armor := &DndArmor{ID: uint(idParam)}
  err := core_module.Db.Model(armor).WherePK().Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }
  json.NewEncoder(w).Encode(armor)
}

///
/// createArmor
///
/// Default method for creating this model.
///
func createArmor(w http.ResponseWriter, r *http.Request) {
  core_module.InitResponse(&w)
  if (r.Method == "OPTIONS") {return}

  var armor DndArmor
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&armor)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&armor).Insert()
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
/// updateArmor
///
/// Default method for updating this model.
///
func updateArmor(w http.ResponseWriter, r *http.Request) {
  core_module.InitResponse(&w)
  if (r.Method == "OPTIONS") {return}

  var armor DndArmor
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&armor)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&armor).WherePK().Update()
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
/// deleteArmor
///
/// Default method for deleting this model.
///
func deleteArmor(w http.ResponseWriter, r *http.Request) {
  core_module.InitResponse(&w)
  if (r.Method == "OPTIONS") {return}

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)
  armor := &DndArmor{ID: uint(idParam)}

  _, err := core_module.Db.Model(armor).WherePK().Delete()
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
