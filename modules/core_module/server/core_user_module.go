///
/// core_user_module.go
/// ~~~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric@attict.net>
///
/// Core Users Sub-module of Core Module
///
///
package core_module

import (
  "log"
  "strings"
  "strconv"
  "time"
  "encoding/json"
  "net/http"

  "github.com/gorilla/mux"
)

///
/// CoreUserModuleID
///
/// This is the core user module ID, representing the module for all users,
/// at least for base user functionality.  Additional functionality should be
/// maintained separate.  Again, these modules will be able to be turned on
/// and off through this ID, so that they can be interchanged with
/// alternatives.  This depends on groups.
///
var CoreUserModuleID uint

///
/// CoreUser
///
/// The CoreUser model for controlling users.
///
/// XXX: Should permissions be saved to the group, then applied to the user,
/// essentially stored on the User?
type CoreUser struct {
  ID            uint        `json:"id"`
  Username      string      `json:"username"        sql:",unique"`
  Password      string      `json:"password"`
  GroupID       uint        `json:"groupId"`
  Group         *CoreGroup  `json:"group"           pg:"has1:core_groups"`
  FirstName     string      `json:"firstName"       sql:",nullable"`
  LastName      string      `json:"lastName"        sql:",nullable"`
  AuthAttempts  uint        `json:"authAttempts"    sql:",nullable"`
  Blocked       bool        `json:"blocked"         sql:",nullable"`
  LastActivity  time.Time   `json:"lastActivity"    sql:",nullable"`
}

///
/// initUsers
///
///
func initUsers(router *mux.Router) {
  // Module
  CoreUserModuleID = AddModule("Core User Module", 1)

  // Model
  model := (*CoreUser)(nil)
  AddModel(model)
  // TODO: Remove password, and use `superPassword`
  password, err := passwordHash("l0lum@d?")
  if err != nil {
    panic(err)
  }
  InsertInitialModel(
    model,
    &CoreUser {
      Username: "admin",
      Password: password,
      GroupID: 1,
      FirstName: "Super",
      LastName: "User",
    },
  )

  // Routes
  router.HandleFunc("/api/core/users", getUsers).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/core/users/{id}", getUser).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/core/users", createUser).Methods("POST", "OPTIONS")
  router.HandleFunc("/api/core/users/{id}", updateUser).Methods("PUT", "OPTIONS")
  router.HandleFunc("/api/core/users/{id}", deleteUser).Methods("DELETE", "OPTIONS")
  router.HandleFunc("/api/core/users/unlock/{id}", unlockUser).Methods("PUT", "OPTIONS")
  router.HandleFunc("/api/core/users/block/{id}", blockUser).Methods("PUT", "OPTIONS")
  router.HandleFunc("/api/core/users/unblock/{id}", unblockUser).Methods("PUT", "OPTIONS")
}

///
/// getUsers
///
///
func getUsers(w http.ResponseWriter, r *http.Request) {
  //InitResponse(&w)
  //if r.Method == "OPTIONS" {return}
  InitResponse(&w)

  allow, auth := HasPermission(&w, r, CoreUserModuleID, CoreAccessRead)

  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    json.NewEncoder(w).Encode(&CoreException{
      Message: "You do not have permission to this resource!",
      Logout: auth == nil,
    })
    return
  }

  //log.Printf("Cookies %d", len(r.Cookies()))
  //cookie, _ := r.Cookie("refresh_token")
  //log.Printf("Cookie access: %s", cookie.Value)

  var users []CoreUser

  err := Db.Model(&users).
    Relation("Group").
    Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    return
  }

  w.WriteHeader(http.StatusOK)
  json.NewEncoder(w).Encode(users)
}

// getUser ; Get's a single user
//
//
func getUser(w http.ResponseWriter, r *http.Request) {
  InitResponse(&w)

  if r.Method == "OPTIONS" {return}

  allow, _ := HasPermission(&w, r, CoreUserModuleID, CoreAccessRead)
  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    json.NewEncoder(w).Encode(&CoreMessage{
      Message: "You do not have access to this resource.",
    })
    return
  }

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  user := &CoreUser{ID: uint(idParam)}
  err := Db.Model(user).
    Column("core_user.*").
    Relation("Group").
    WherePK().
    Select()
  if err != nil {
    w.WriteHeader(http.StatusNotFound)
    return
  }

  w.WriteHeader(http.StatusOK)
  json.NewEncoder(w).Encode(user)
}

// create
//
//
func createUser(w http.ResponseWriter, r *http.Request) {
  InitResponse(&w)

  if r.Method == "OPTIONS" {return}

  allow, auth := HasPermission(&w, r, CoreUserModuleID, CoreAccessCreate)
  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    json.NewEncoder(w).Encode(&CoreMessage{
      Message: "You do not have access to this resource.",
    })
    return
  }

  var user CoreUser
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&user)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    return
  }

  if len(user.Username) < 3 {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&CoreMessage{
      Message: "Username must be at least 3 characters.",
    })
    return
  }

  // TODO: Check group weight.
  if auth == nil || user.Group == nil {
    user.GroupID = 2 // Standard User
  } else {
    user.GroupID = user.Group.ID
  }

  if user.GroupID == 1 {
    w.WriteHeader(http.StatusForbidden)
    json.NewEncoder(w).Encode(&CoreError{
      Error: true,
      Message: "Cannot create super user.",
    })
    return
  }

  user.Username = strings.ToLower(user.Username)
  log.Println(user.Password);
  password, err := passwordHash(user.Password)
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
  }
  user.Password = password

  _, err = Db.Model(&user).Insert()
  if err != nil {
    w.WriteHeader(http.StatusInternalServerError)
    return
  }

  w.WriteHeader(http.StatusAccepted)
}


// update
//
//
func updateUser(w http.ResponseWriter, r *http.Request) {
  InitResponse(&w)

  if r.Method == "OPTIONS" {return}

  allow, _ := HasPermission(&w, r, CoreUserModuleID, CoreAccessUpdate)
  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    return
  }

  var user CoreUser
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&user)

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    return
  }

  user.GroupID = user.Group.ID

  if user.GroupID == 1 {
    w.WriteHeader(http.StatusForbidden)
    json.NewEncoder(w).Encode(&CoreError{
      Error: true,
      Message: "Cannot set super group.",
    })
    return
  }

  if user.ID == 1 {
    w.WriteHeader(http.StatusForbidden)
    json.NewEncoder(w).Encode(&CoreError{
      Error: true,
      Message: "Cannot update super user.",
    })
    return
  }

  user.Username = strings.ToLower(user.Username)

  _, err = Db.Model(&user).WherePK().Update()
  if err != nil {
    w.WriteHeader(http.StatusInternalServerError)
    return
  }

  json.NewEncoder(w).Encode(&user)
}

// delete
//
//
func deleteUser(w http.ResponseWriter, r *http.Request) {
  InitResponse(&w)

  if r.Method == "OPTIONS" {return}

  allow, _ := HasPermission(&w, r, CoreUserModuleID, CoreAccessDelete)
  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    return
  }

  params := mux.Vars(r)
  id, _ := strconv.ParseUint(params["id"], 10, 16)

  if id == 1 {
    w.WriteHeader(http.StatusForbidden)
    json.NewEncoder(w).Encode(&CoreError{
      Error: true,
      Message: "Cannot delete super user.",
    })
    return
  }

  user := &CoreUser{ID: uint(id)}
  _, err := Db.Model(user).WherePK().Delete()
  if err != nil {
    w.WriteHeader(http.StatusInternalServerError)
    return
  }

  w.WriteHeader(http.StatusAccepted)
}

// unlock user
//
//
func unlockUser(w http.ResponseWriter, r *http.Request) {
  InitResponse(&w)

  if r.Method == "OPTIONS" {return}

  allow, _ := HasPermission(&w, r, CoreUserModuleID, CoreAccessUpdate)
  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    return
  }

  params := mux.Vars(r)
  id, _ := strconv.ParseUint(params["id"], 10, 16)

  user := &CoreUser{ID: uint(id), AuthAttempts: 0}
  _, err := Db.Model(user).Column("auth_attempts").WherePK().Update()
  if err != nil {
    w.WriteHeader(http.StatusNotFound)
    return
  }

  w.WriteHeader(http.StatusAccepted);
}

// BLOCK USER
//
//
func blockUser(w http.ResponseWriter, r *http.Request) {
  InitResponse(&w)

  if r.Method == "OPTIONS" {return}

  allow, _ := HasPermission(&w, r, CoreUserModuleID, CoreAccessUpdate)
  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    return
  }

  params := mux.Vars(r)
  id, _ := strconv.ParseUint(params["id"], 10, 16)

  if id == 1 {
    w.WriteHeader(http.StatusForbidden)
    json.NewEncoder(w).Encode(&CoreError{
      Error: true,
      Message: "Cannot block super user.",
    })
    return
  }

  user := &CoreUser{ID: uint(id), Blocked: true}
  _, err := Db.Model(user).Column("blocked").WherePK().Update()
  if err != nil {
    w.WriteHeader(http.StatusNotFound)
    return
  }

  w.WriteHeader(http.StatusAccepted)
}

// UNBLOCK USER
//
//
func unblockUser(w http.ResponseWriter, r *http.Request) {
  InitResponse(&w)

  if r.Method == "OPTIONS" {return}

  allow, _ := HasPermission(&w, r, CoreUserModuleID, CoreAccessUpdate)
  if !allow {
    return
  }

  params := mux.Vars(r)
  id, _ := strconv.ParseUint(params["id"], 10, 16)

  if id == 1 {
    w.WriteHeader(http.StatusForbidden)
    json.NewEncoder(w).Encode(&CoreError{
      Error: true,
      Message: "Cannot unblock super user.",
    })
    return
  }

  user := &CoreUser{ID: uint(id), Blocked: false}
  _, err := Db.Model(user).Column("blocked").WherePK().Update()
  if err != nil {
    w.WriteHeader(http.StatusNotFound)
    return
  }

  w.WriteHeader(http.StatusAccepted)
}
