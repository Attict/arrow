package core_module

import (
  "encoding/json"
  "log"
  "net/http"
  "os"
  "strconv"
  "strings"
  "time"

  "golang.org/x/crypto/bcrypt"

  "github.com/dgrijalva/jwt-go"
  "github.com/gorilla/mux"
  "github.com/go-pg/pg"
  "github.com/go-pg/pg/orm"
)

// -----------------------------------------------------------------------------
// CONSTANTS

// Environment Options : This is the assigned to the current running
// environment, such as development, testing, production, etc.
//
const (
  EnvironmentDevelopment        = 0
  EnvironmentProduction         = 1
)

// -----------------------------------------------------------------------------
// MODELS

// CoreModule : The CoreModule model for controlling which modules
// are enabled and disabled.
// TODO: When a user tries to give access to non-users, have a warning
// pop up to warn them that this is a dangerous permission.
type CoreModule struct {
  ID        uint    `json:"id"`
  Parent    uint    `json:"parent"  sql:",nullable"`
  Label     string  `json:"label"`
  Enabled   bool    `json:"enabled" sql:",default:true"`
}

///
/// CoreMessage
///
/// Used for sending errors with a message.
///
type CoreMessage struct {
  Title                 string              `json:"title"`
  Message               string              `json:"message"`
}

// -----------------------------------------------------------------------------
// PUBLIC VARIABLES

// CoreModuleID : This is the core module ID, and the only necessary dependency
// for the entire application.  This cannot be turned off, and also
// handles all core + module functionality.
var CoreModuleID uint

// Db : The database object shared across all modules.  Other modules should
// use this object to access the database with `core_module.Db`
//
var Db pg.DB

// Environment : The running environment based on a constant above.
//
//
var Environment uint8

// JwtKey : The jwt key for tokens.  This should be stored in a file called
// .jwtkey, and then parsed by the application
//
var JwtKey []byte

// -----------------------------------------------------------------------------
// PUBLIC FUNCTIONS

// Init : Every module should have an `Init` function where routes
// will be initialized; the module will be inserted into the database,
// if not already;  The database will be initialized with the models,
// and typically a sample of the data.
func Init(router *mux.Router) {
  initDb()
  initModules(router)
  initGroups(router)
  initUsers(router)
  initAuthentication(router)
  initPermission()

  // Route initialization

  // Database initialization
  //
  // XXX: In development, the database should be wiped each time.

  // Module insert
  //
}

// SetOptions : Handles the OPTIONS request.  Currently
// this is only enabled in development, so that no other websites can access
// the data from another origin.
func InitResponse(w *http.ResponseWriter) {
  if Environment == EnvironmentDevelopment {
    (*w).Header().Set("Allow", "*")
    (*w).Header().Set("Access-Control-Allow-Methods", "*")
    (*w).Header().Set("Access-Control-Allow-Origin", "http://localhost:4900")
    (*w).Header().Set("Access-Control-Allow-Headers", "Authorization, Content-Type")
    (*w).Header().Set("Access-Control-Allow-Credentials", "true")
  }
}

// HasPermission : Valids the incoming auth header, and then checks the user
// for permission to access whatever the accessReq matches in the moduleIDs
// permission, with user permissions
func HasPermissionOld(
  w *http.ResponseWriter,
  r *http.Request,
  moduleID uint,
  accessReq uint,
) (bool, *CoreAuthentication) {

  // Get auth for group ID
  valid, auth := jwtValidParse(r)

  if moduleID == 0 {
    return true, auth
  }

  // Super User always has access
  if valid && auth.GroupID == 1 && auth.UserID == 1 {
    return true, auth
  }

  // Get the permission for this group and module by ID
  var permissions []CorePermission
  groups := []uint{0, auth.GroupID}
  Db.Model(&permissions).
      Where("module_id = ?", moduleID).
      Where("group_id in (?)", pg.In(groups)).
      Select()

  // Any permission for non-users, requires group ID of zero
  var anyPermission *CorePermission

  // Auth permissions associated with requesting user's group ID
  var authPermission *CorePermission

  // Assign permissions if they exist in the array
  for _, v := range permissions {
    if v.GroupID == 0 {
      anyPermission = &v
    } else if auth.GroupID == v.GroupID {
      authPermission = &v
    }
  }

  if !valid && anyPermission == nil {
    return false, auth
  }

  if anyPermission == nil {
    anyPermission = &CorePermission{
      Read:   CorePermissionNone,
      Create: CorePermissionNone,
      Update: CorePermissionNone,
      Delete: CorePermissionNone,
    }
  }

  if authPermission == nil {
    authPermission = &CorePermission{
      Read:   CorePermissionNone,
      Create: CorePermissionNone,
      Update: CorePermissionNone,
      Delete: CorePermissionNone,
    }
  }

  if accessReq == CoreAccessCreate {
    if anyPermission.Create == CorePermissionAll ||
       authPermission.Create == CorePermissionAll {
      return true, auth
    }
  } else if accessReq == CoreAccessUpdate {
    if anyPermission.Update == CorePermissionAll ||
       authPermission.Update == CorePermissionAll {
      return true, auth
    }
  } else if accessReq == CoreAccessDelete {
    if anyPermission.Delete == CorePermissionAll ||
       authPermission.Delete == CorePermissionAll {
      return true, auth
    }
  } else { // CoreAccesRead
    if anyPermission.Read == CorePermissionAll ||
       authPermission.Read == CorePermissionAll {
      return true, auth
    }
  }

  return false, auth
}

// AddModule : This adds the module to the core modules table, but first checks
// for the exisiting name, and WILL NOT override it.
//
func AddModule(label string, parent uint) uint  {
  module := &CoreModule{
    Label: label,
    Parent: parent,
  }
  count, err := Db.Model((*CoreModule)(nil)).Where("Label = ?", label).Count()
  if count == 0 {
    _, err = Db.Model(module).Returning("id").Insert()
    if err != nil {
      panic(err)
    }
  } else {
    err = Db.Model(module).Where("Label = ?", label).Select()
  }
  if err != nil {
    panic(err)
  }
  return module.ID
}

// AddModel : Adds a model to the database as a new table.
//
//
func AddModel(model interface{}) {
  err := Db.CreateTable(model, &orm.CreateTableOptions{
    IfNotExists: true,
  })
  if err != nil {
    panic(err)
  }
}

func SetPermission(permission CorePermission) {
  count, err := Db.Model((*CorePermission)(nil)).
    Where("module_id = ?", permission.ModuleID).
    Where("group_id = ?", permission.GroupID).
    Count()

  if err != nil {
    panic(err)
  }

  if count == 0 {
    // Insert
    _, err = Db.Model(&permission).Insert()
  } else {
    _, err = Db.Model(&permission).
      Where("module_id = ?", permission.ModuleID).
      Where("group_id = ?", permission.GroupID).
      UpdateNotZero()
  }

  if err != nil {
    panic(err)
  }
}

// InsertInitialModel : Inserts a basic initial model
//
//
func InsertInitialModel(model interface{}, value ...interface{}) {
  if TableIsEmpty(model) {
    _, err := Db.Model(&value).Insert()
    if err != nil {
      panic(err)
    }
  }
}

// TableIsEmpty : Used for initially creating a table, for
// modules which should insert the first items.
//
func TableIsEmpty(model interface{}) bool {
  count, err := Db.Model(model).Count()
  if err != nil {
    panic(err)
  }
  return count == 0
}


/// ----------------------------------------------------------------------------
/// PRIVATE VARIABLES


/// ----------------------------------------------------------------------------
/// PRIVATE FUNCTIONS

func logout(w *http.ResponseWriter) {
  accessCookie := http.Cookie{
    Name: "access_token",
    Value: "",
    Path: "/",
    HttpOnly: true,
    MaxAge: -1,
  }
  refreshCookie := http.Cookie{
    Name: "refresh_token",
    Value: "",
    Path: "/",
    HttpOnly: true,
    MaxAge: -1,
  }
  http.SetCookie((*w), &accessCookie)
  http.SetCookie((*w), &refreshCookie)

}

func HasPermission(
  w *http.ResponseWriter,
  r *http.Request,
  moduleID uint,
  accessReq uint,
) (bool, *CoreAuthentication) {
  auth := validateUser(w, r)
  groupID := uint(0)

  if auth == nil {
    logout(w)
    return false, nil
  }

  if auth != nil {
    groupID = auth.GroupID
  }

  if groupID == 1 {
    return true, auth
  }

  return false, auth
}

func validateUser(w *http.ResponseWriter, r *http.Request) *CoreAuthentication {
  accessCookie, _ := r.Cookie("access_token")
  if accessCookie != nil {
    auth := validateToken(accessCookie.Value)
    if auth != nil {
      return auth
    }
  }

  refreshCookie, _ := r.Cookie("refresh_token")
  if refreshCookie != nil {
    auth := validateToken(refreshCookie.Value)
    if auth != nil {
      refreshAccess(w, auth)
      //createAccessCookie(auth)
      return auth
    }
  }

  // logout
  return nil
}

///
/// refreshAccess
///
/// TODO
///     - Should this return a string error?
///
func refreshAccess(w *http.ResponseWriter, auth *CoreAuthentication) {
  user := &CoreUser{ID: auth.UserID}
  err := Db.Model(user).Column("username", "first_name", "last_name", "group_id", "blocked").WherePK().Select()

  /// Database error
  if err != nil {
    log.Printf("Refresh access error: %s", err)
    return
  }

  // User blocked
  if user.Blocked {
    log.Println("Refresh access user blocked")
    return
  }

  auth.GroupID = user.GroupID
  user.LastActivity = time.Now()
  _, err = Db.Model(user).Column("last_activity").WherePK().Update()
  if err != nil {
    log.Printf("Refresh access error: %s", err)
    return
  }

  expirationTime := time.Now().Add(5 * time.Minute)
  auth.ExpiresAt = expirationTime.Unix()
  token := jwt.NewWithClaims(jwt.SigningMethodHS256, auth)
  tokenString, err := token.SignedString(JwtKey)
  if err != nil {
    log.Printf("Refresh access error: %s", err)
    return
  }

  accessCookie := http.Cookie{
    Name: "access_token",
    Value: tokenString,
    Expires: expirationTime,
    HttpOnly: true,
    Path: "/",
  }
  http.SetCookie(*w, &accessCookie)
}

func validateToken(tokenValue string) *CoreAuthentication {
  auth := &CoreAuthentication{}
  token, err := jwt.ParseWithClaims(
    tokenValue,
    auth,
    func(token *jwt.Token) (interface{}, error) {
      return JwtKey, nil
    },
  )

  if err != nil {
    log.Printf("Token error: %s", err)
    return nil
  }

  if token.Valid {
    return auth
  }

  return nil
}

// jwtValidParse : Parses the jwt token, and returns if it is valid,
// and the parsed claims.
//
func jwtValidParse(r *http.Request) (bool, *CoreAuthentication) {
  // Auth to be returned at the end.
  auth := &CoreAuthentication{}

  requestAuth := r.Header.Get("Authorization")
  if requestAuth == "" {
    return false, auth
  }
  tokenValue := strings.TrimPrefix(requestAuth, "Bearer ")

  token, err := jwt.ParseWithClaims(
    tokenValue,
    auth,
    func(token *jwt.Token) (interface{}, error) {
      return JwtKey, nil
    },
  )


  // Check for matching browser
  if r.UserAgent() != auth.UserAgent {
    return false, auth
  }

  // Successfully validated
  if err == nil || token.Valid {
    return true, auth
  }

  return false, auth
}

// passwordValid : Checks if a password is valid.
//
//
func passwordValid(password, hash string) bool {
  err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
  return err == nil
}

//
//
//
func passwordHash(password string) (string, error) {
  bytes, err := bcrypt.GenerateFromPassword([]byte(password), 14)
  return string(bytes), err
}

//
//
//
func initDb() {
  if os.Getenv("APP_ENV") == "eric" {
    Db = *pg.Connect(&pg.Options{
      Addr:     "localhost:5432",
      User:     "eric",
      Database: "arrow_api",
    })
  } else if os.Getenv("APP_ENV") != "production" {
    Db = *pg.Connect(&pg.Options{
      Addr:     "localhost:5432",
      User:     "attict",
      Database: "arrow_api",
    })
  } else {
    Db = *pg.Connect(&pg.Options{
      Addr:     "database:5432",
      User:     "postgres",
      Database: "api",
    })
  }
}


// -----------------------------------------------------------------------------
// MODULES

func initModules(router *mux.Router) {
  // Add Model, only in this module, is this neccessary to be first,
  // before `AddModule`
  AddModel((*CoreModule)(nil))

  // Add Module
  AddModule(
    "Core Module",          // Label
    0,                      // Parent
  )

  // Routes
  router.HandleFunc("/api/core/modules", getModules).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/core/modules/{id}", getModule).Methods("GET", "OPTIONS")
}

func getModules(w http.ResponseWriter, r *http.Request) {
  InitResponse(&w)

  if r.Method == "OPTIONS" {return}

  allow, _ := HasPermission(&w, r, CoreModuleID, CoreAccessRead)
  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    return
  }

  var modules []CoreModule

  err := Db.Model(&modules).Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    return
  }

  w.WriteHeader(http.StatusOK)
  json.NewEncoder(w).Encode(modules)
}

func getModule(w http.ResponseWriter, r *http.Request) {
  InitResponse(&w)

  if r.Method == "OPTIONS" {return}

  allow, _ := HasPermission(&w, r, CoreModuleID, CoreAccessRead)
  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    return
  }

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  module := &CoreModule{ID: uint(idParam)}
  err := Db.Model(module).WherePK().Select()
  if err != nil {
    w.WriteHeader(http.StatusNotFound)
    return
  }

  w.WriteHeader(http.StatusOK)
  json.NewEncoder(w).Encode(module)
}





/// TEMPORARY
func SetHeaders(w *http.ResponseWriter) {
  if os.Getenv("APP_ENV") != "production" {
    (*w).Header().Set("Allow", "*")
    (*w).Header().Set("Access-Control-Allow-Methods", "*")
    (*w).Header().Set("Access-Control-Allow-Origin", "*")
    (*w).Header().Set("Access-Control-Allow-Headers", "Authorization, Content-Type")
  }
}
type CoreException struct {
  Title                 string              `json:"title"`
  Message               string              `json:"message"`
  Logout                bool                `json:"logout"`
}


type CoreError struct {
  Error     bool    `json:"error"`
  Message   string  `json:"message"`
}
