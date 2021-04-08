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
  WeaponType_SimpleMelee = 1
  WeaponType_SimpleRanged = 2
  WeaponType_MartialMelee = 3
  WeaponType_MartialRanged = 4

  WeaponDamage_Bludgeoning = 1
  WeaponDamage_Piercing = 2
  WeaponDamage_Slashing = 3
)

type DndWeapon struct {
  ID                    uint                `json:"id"`
  Item                  DndItem             `json:"item"`
  Type                  uint8               `json:"type"`
  MinDmg                uint16              `json:"minDmg"`
  MaxDmg                uint16              `json:"maxDmg"`
  DmgType               uint16              `json:"dmgType"`
  ModType               uint8               `json:"modType"`
  MinRange              uint16              `json:"minRange"`
  MaxRange              uint16              `json:"maxRange"`
  Properties            string              `json:"properties"`
  ProfIDs               []uint              `json:"profIds"`
}

func initWeapon(router *mux.Router) {
  core_module.AddModel((*DndWeapon)(nil));
  router.HandleFunc("/api/dnd/weapons", getWeapons).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/weapons/{id}", getWeapon).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/weapons", createWeapon).Methods("POST", "OPTIONS")
  router.HandleFunc("/api/dnd/weapons", updateWeapon).Methods("PUT", "OPTIONS")
  router.HandleFunc("/api/dnd/weapons/{id}", deleteWeapon).Methods("DELETE", "OPTIONS")
}

/// ----------------------------------------------------------------------------
/// HTTP
///

func getWeapons(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  weapons := []DndWeapon{}

  err := core_module.Db.Model(&weapons).Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(weapons)
}

///
/// getWeapon
///
///
func getWeapon(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  weapon := &DndWeapon{ID: uint(idParam)}
  err := core_module.Db.Model(weapon).WherePK().Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }
  json.NewEncoder(w).Encode(weapon)
}

///
/// createWeapon
///
/// HTTP handler for creating a new weapon.
///
func createWeapon(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var weapon DndWeapon
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&weapon)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&weapon).Insert()
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
/// updateWeapon
///
///
func updateWeapon(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var weapon DndWeapon
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&weapon)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&weapon).WherePK().Update()
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
/// deleteWeapon
///
///
func deleteWeapon(w http.ResponseWriter, r *http.Request) {
  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  weapon := &DndWeapon{ID: uint(idParam)}
  _, err := core_module.Db.Model(weapon).WherePK().Delete()
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
