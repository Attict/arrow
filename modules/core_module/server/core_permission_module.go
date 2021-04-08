package core_module

// CorePermissionModuleID : This is the core permission module ID,
// representing permissions for accessing the proper accesses.  This module
// will contain userID, moduleID, access
var CorePermissionModuleID uint

// CorePermission : The CorePermission model, which will be added to
// users and groups as permissions.  This is not stored in the database
// uniquely, but rather stored directly with the objects as json.
// XXX: is this stored as json on the group, but stored in a separate
// permissions table for the user, for quick indexing lookup.
// XXX: This will no longer be added to users, since it will create
// too much complication for users, because if the permission on the user
// changed, then it will no longer be controlled by the group.  Users
// would then have to remember each individual user's unique permissions,
// and that they are not changed by the group.
type CorePermission struct {
  ModuleID  uint
  GroupID   uint    `json:"moduleId"    sql:",use_zero,default:0"`
  Read      uint8   `json:"read"        sql:",use_zero,default:0"`
  Create    uint8   `json:"create"      sql:",use_zero,default:0"`
  Update    uint8   `json:"update"      sql:",use_zero,default:0"`
  Delete    uint8   `json:"delete"      sql:",use_zero,default:0"`
}

// Core Permission Options : This is for permissions.  Controls whether a
// permission has READ, CREATE, UPDATE, DELETE access to MINE ONLY,
// AUTHORITY LEVEL (this will be a numeric value, where higher can access lower
// but lower cannot access higher), or ALL (without restriction).
//
// TODO: CorePermissionAsOther - Allowing user to control who the user is.
const (
  CorePermissionNone                    = 0
  CorePermissionAll                     = 1
  CorePermissionAuthority               = 2
  CorePermissionMine                    = 3
  CorePermissionAuthorityIncludeEqual   = 4
  CorePermissionAsAnother               = 5
)

// Core Access Options : These are the types of access allowed by permissions.
// Read, Create, Update or Delete in the module, then allow what
// permission they have over other users.
const (
  CoreAccessRead    = 1
  CoreAccessCreate  = 2
  CoreAccessUpdate  = 3
  CoreAccessDelete  = 4
)

// -----------------------------------------------------------------------------
// PERMISSION

// initPermission :
// NOTE: No permission router, because this is not accessible outside the
// server.
func initPermission() {
  CorePermissionModuleID = AddModule("Core Permission Module", 1)

  model := (*CorePermission)(nil)
  AddModel(model)

  // Temp
  InsertInitialModel(
    model,
    &CorePermission{
      ModuleID: CoreGroupModuleID,
      GroupID: 3,
      Read: CorePermissionAll,
      Create: CorePermissionAll,
      Update: CorePermissionNone,
      Delete: CorePermissionNone,
    },
  )
}
