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
/// DndItemModuleID
///
/// The ID for this submodule.  Used for accessing resources.
///
var DndItemModuleID uint

///
/// CONST
///
/// Constants for [ItemType] values.
///
const (
  ItemType_General = 1
  ItemType_Weapon = 2
  ItemType_Armor = 3
  ItemType_Offhand = 4
  ItemType_Potion = 5
  ItemType_Scroll = 6
  ItemType_Ammunition = 7
)

///
/// DndItem
///
/// The model for this module.
///
type DndItem struct {
  ID                    uint                `json:"id"`
  Name                  string              `json:"name"`
  Desc                  string              `json:"desc" pg:"type:text"`
  Type                  uint8               `json:"type"`
  Price                 float64             `json:"price"`
  Weight                float32             `json:"weight"`
  ProfID                uint                `json:"profId"`
}

///
/// initItem
///
/// Initializes this sub-module, creating the module with it's ID.  Then
/// creates the database table, and sets the routes.
///
func initItem(router *mux.Router) {
  core_module.AddModel((*DndItem)(nil));
  router.HandleFunc("/api/dnd/items", getItems).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/items/type/{id}", getItemsByType).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/items/{id}", getItem).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/items", createItem).Methods("POST", "OPTIONS")
  router.HandleFunc("/api/dnd/items", updateItem).Methods("PUT", "OPTIONS")
  router.HandleFunc("/api/dnd/items/{id}", deleteItem).Methods("DELETE", "OPTIONS")
}

/// ----------------------------------------------------------------------------
/// ROUTES

///
/// getItems
///
/// Default method for getting all of this model.
///
func getItems(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  items := []DndItem{}

  err := core_module.Db.Model(&items).Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(items)
}


///
/// getItemByType
///
/// Get's all Items by a type.
///
func getItemsByType(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  items := []DndItem{}

  err := core_module.Db.Model(&items).Where("type = ?", idParam).Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(items)
}

///
/// getItem
///
/// Default method for getting a single model.
///
func getItem(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  item := &DndItem{ID: uint(idParam)}
  err := core_module.Db.Model(item).WherePK().Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }
  json.NewEncoder(w).Encode(item)
}

///
/// createItem
///
/// Default method for creating this model.
///
func createItem(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var item DndItem
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&item)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&item).Insert()
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
/// updateItem
///
/// Default method for updating this model.
///
func updateItem(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var item DndItem
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&item)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&item).WherePK().Update()
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
/// deleteItem
///
/// Default method for deleting this model.
///
func deleteItem(w http.ResponseWriter, r *http.Request) {
  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  item := &DndItem{ID: uint(idParam)}
  _, err := core_module.Db.Model(item).WherePK().Delete()

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
