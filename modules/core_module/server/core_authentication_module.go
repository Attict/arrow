package core_module

import (
  "encoding/json"
  "log"
  "net/http"
  "time"

  "github.com/dgrijalva/jwt-go"
  "github.com/gorilla/mux"
)

///
/// CoreAuthenticationModuleID
///
/// This is the core authentication module ID,
/// representing the module for all authentication allowing users to sign in.
/// Since the architecture is top down, starting at core, and ending at
/// authentication, this is dependent on the users.
///
var CoreAuthenitcationModuleID uint

///
/// CoreAuthentication
///
/// The CoreAuthentication to be stored in the token,
/// and sent to the client.
///
/// XXX: This will be used for both the refresh and access token.
///
type CoreAuthentication struct {
  UserID    uint        `json:"userId"`
  GroupID   uint        `json:"groupId"`
  UserAgent string      `json:"userAgent"`
  jwt.StandardClaims
}

///
/// CoreCredentials
///
/// Credentials for username and password
///
type CoreCredentials struct {
  Username  string  `json:"username"`
  Password  string  `json:"password"`
}

///
/// CoreLogin
///
/// Information returned on login.
///
type CoreLogin struct {
  //AccessToken   string      `json:"accessToken"`
  //RefreshToken  string      `json:"refreshToken"`
  User          *CoreUser   `json:"user"`
}

// -----------------------------------------------------------------------------
// AUTHENTICATION

func initAuthentication(router *mux.Router) {
  CoreAuthenitcationModuleID = AddModule("Core Authentication Module", 1)
  // Login
  router.HandleFunc(
    "/api/core/authentication",
    authenticate,
  ).Methods("POST", "OPTIONS")

  // Refresh tokens
  router.HandleFunc(
    "/api/core/authentication/refresh",
    authenticateRefresh,
  ).Methods("POST", "OPTIONS")

  router.HandleFunc(
    "/api/core/authentication/logout",
    authenticateLogout,
  ).Methods("POST", "OPTIONS")
}

// authenticate : Attempts to log a user in.
//
//
func authenticate(w http.ResponseWriter, r *http.Request) {
  InitResponse(&w)

  // Decode the credentials
  var credentials CoreCredentials
  decoder := json.NewDecoder(r.Body)
  err := decoder.Decode(&credentials)
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    return
  }

  // Get the user
  var user CoreUser
  err = Db.Model(&user).
    Relation("Group").
    Where("username = ?", credentials.Username).
    Select()

  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&CoreMessage{
      Message: "Invalid Username or Password.",
    })
    return
  }

  if user.Blocked {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&CoreMessage{
      Message: "Account Blocked!",
    })
    return
  }

  if user.AuthAttempts > 4 {
    w.WriteHeader(http.StatusBadRequest)
    json.NewEncoder(w).Encode(&CoreMessage{
      Message: "Account Locked!",
    })
    return
  }

  if passwordValid(credentials.Password, user.Password) {
    user.AuthAttempts = 0
    user.LastActivity = time.Now()
    Db.Model(&user).Column(
      "auth_attempts",
      "last_activity",
    ).WherePK().Update()

    // Generate the access token
    expirationTime := time.Now().Add(5 * time.Minute)
    auth := &CoreAuthentication{
      UserID:  user.ID,
      GroupID: user.GroupID,
      UserAgent: r.UserAgent(),
      StandardClaims: jwt.StandardClaims{
        ExpiresAt: expirationTime.Unix(),
      },
    }

    token := jwt.NewWithClaims(jwt.SigningMethodHS256, auth)
    tokenString, err := token.SignedString(JwtKey)
    if err != nil {
      w.WriteHeader(http.StatusInternalServerError)
      log.Println(err)
      return
    }

    // Generate the refresh token
    refreshExpireTime := time.Now().Add(24 * time.Hour)
    refreshClaims := &CoreAuthentication{
      UserID:  user.ID,
      GroupID: user.GroupID,
      UserAgent: r.UserAgent(),
      StandardClaims: jwt.StandardClaims{
        ExpiresAt: refreshExpireTime.Unix(),
      },
    }

    refreshToken := jwt.NewWithClaims(jwt.SigningMethodHS256, refreshClaims)
    refreshTokenStr, err := refreshToken.SignedString(JwtKey)
    if err != nil {
      w.WriteHeader(http.StatusInternalServerError)
      log.Println(err)
      return
    }

    accessCookie := http.Cookie{
      Name: "access_token",
      Value: tokenString,
      Expires: expirationTime,
      HttpOnly: true,
    }
    refreshCookie := http.Cookie{
      Name: "refresh_token",
      Value: refreshTokenStr,
      Expires: refreshExpireTime,
      HttpOnly: true,
    }
    http.SetCookie(w, &accessCookie)
    http.SetCookie(w, &refreshCookie)

    response := &CoreLogin{
      //AccessToken:  tokenString,
      //RefreshToken: refreshTokenStr,
      User:         &user,
    }

    json.NewEncoder(w).Encode(&response)
    return
  }

  user.AuthAttempts++
  Db.Model(&user).Column("auth_attempts").WherePK().Update()

  w.WriteHeader(http.StatusBadRequest)
  json.NewEncoder(w).Encode(&CoreMessage{
    Message: "Invalid Username or Password",
  })
}

// authenticateRefresh : Attempts to refresh a users access token.
//
//
func authenticateRefresh(w http.ResponseWriter, r *http.Request) {
  InitResponse(&w)
  if r.Method == "OPTIONS" {return}

  // Check if the token is valid
  allow, auth := jwtValidParse(r)
  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    return
  }

  // Check if the user has changed groups, or has been blocked
  user := &CoreUser{ID: auth.UserID}
  err := Db.Model(user).Column("username", "first_name", "last_name", "group_id", "blocked").WherePK().Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    return
  }

  // Blocked return
  if user.Blocked {
    w.WriteHeader(http.StatusForbidden)
    json.NewEncoder(w).Encode(&CoreError{
      Error: true,
      Message: "You have been blocked!",
    })
    return
  }

  // Update group
  auth.GroupID = user.GroupID
  //auth.UserAgent = r.UserAgent()

  // Update the last activity for the user.
  user.LastActivity = time.Now()
  _, err = Db.Model(user).Column("last_activity").WherePK().Update()
  if err != nil {
    w.WriteHeader(http.StatusForbidden)
    return
  }

  // Create the new Token
  expirationTime := time.Now().Add(5 * time.Minute)
  auth.ExpiresAt = expirationTime.Unix()
  token := jwt.NewWithClaims(jwt.SigningMethodHS256, auth)
  tokenString, err := token.SignedString(JwtKey)
  if err != nil {
    w.WriteHeader(http.StatusInternalServerError)
    return
  }

  accessCookie := http.Cookie{
    Name: "access_token",
    Value: tokenString,
    Expires: expirationTime,
    HttpOnly: true,
    Path: "/",
  }
  http.SetCookie(w, &accessCookie)

  // Finally, return the new access token
  json.NewEncoder(w).Encode(&CoreLogin{
    //AccessToken: tokenString,
    User: user,
  })
}

func authenticateLogout(w http.ResponseWriter, r *http.Request) {
  logout(&w)
  w.WriteHeader(http.StatusAccepted)
}
