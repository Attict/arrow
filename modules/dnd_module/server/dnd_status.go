package dnd_module;

import (
  "encoding/json"
  "log"
  "net/http"
  "strconv"
  "time"

  "github.com/gorilla/mux"

  "../../core_module/server"
)

type DndStatus struct {
  ID                    uint                `json:"id"`
  UserID                uint                `json:"userId"`
  CharacterID           uint                `json:"characterId"`
  Message               string              `json:"message" pq:"type:text"`
  Created               time.Time           `json:"created"`
  Modified              time.Time           `json:"modified"`
}

func initStatus(router *mux.Router) {
  core_module.AddModel((*DndStatus)(nil));
  core_module.InsertInitialModel(
    (*DndStatus)(nil),
    &DndStatus{
      UserID: 1,
      CharacterID: 1,
      Message: "Traveled to the local temple to meditate.",
      Created: time.Now(),
    },
  )

  router.HandleFunc("/api/dnd/statuses", getStatuses).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/statuses/{id}", getStatus).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/dnd/statuses", createStatus).Methods("POST", "OPTIONS")
  router.HandleFunc("/api/dnd/statuses", updateStatus).Methods("PUT", "OPTIONS")
  router.HandleFunc("/api/dnd/statuses/{id}", deleteStatus).Methods("DELETE", "OPTIONS")
}

/// ----------------------------------------------------------------------------
/// HTTP
///

func getStatuses(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var statuss []DndStatus

  err := core_module.Db.Model(&statuss).Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }

  json.NewEncoder(w).Encode(statuss)
}

///
/// getStatus
///
///
func getStatus(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  status := &DndStatus{ID: uint(idParam)}
  err := core_module.Db.Model(status).WherePK().Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not fetch!",
    })
    log.Println(err)
    return
  }
  json.NewEncoder(w).Encode(status)
}

///
/// createStatus
///
/// HTTP handler for creating a new status.
///
func createStatus(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var status DndStatus
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&status)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&status).Insert()
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
/// updateStatus
///
///
func updateStatus(w http.ResponseWriter, r *http.Request) {
  core_module.SetHeaders(&w)

  var status DndStatus
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&status)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&core_module.CoreException{
      Message: "Could not decode!",
    })
    log.Println(err)
    return
  }

  _, err = core_module.Db.Model(&status).WherePK().Update()
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
/// deleteStatus
///
///
func deleteStatus(w http.ResponseWriter, r *http.Request) {
  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  status := &DndStatus{ID: uint(idParam)}
  _, err := core_module.Db.Model(status).WherePK().Delete()
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
