package core_module

import (
  "time"
  "net/http"
  "github.com/gorilla/mux"
)

// CoreNotificationModuleID :
//
//
var CoreNotificationModuleID uint

//
//
//
const (
  CoreNotificationStatusUnread = 0
  CoreNotificationStatusRead = 1
)

// CoreNotification :
//
//
type CoreNotification struct {
  ID                uint        `json:"id"`
  Title             string      `json:"title"`
  Message           string      `json:"message"`
  When              time.Time   `json:"when"`
  Created           time.Time   `json:"created"`
}

// CoreNotificationStatus : Users will be attached through this table,
// and then updated through the status.
//
type CoreNotificationStatus struct {
  ID                uint        `json:"id"`
  NotificationID    uint        `json:"notificationId"`
  UserID            uint        `json:"userId"`
  Status            uint8       `json:"status"`
}

// Init :
//
//
func initNotifications(router *mux.Router) {
  // Module
  CoreNotificationModuleID = AddModule("Core Notification Module", 1)

  // Model
  model := (*CoreNotification)(nil)
  AddModel(model)

  // Routes
  router.HandleFunc("/api/notifications", httpGetNotifications).
      Methods("GET", "OPTIONS")
}

// getNotifications : DEVELOPMENT - This is toying with a new idea...
//
// Splitting the HTTP request from the data request.  This way websockets
// can access the dataset, as well as prior http requests.
func getNotifications(userID uint) ([]*CoreNotification, error) {
  // First, get the statuses for the user id provided,
  // then match the notificationID to the notification,
  // pulling all matches for userID + notificationID out of the DB,
  // then returning.

  notifications := []*CoreNotification{
    &CoreNotification{
      ID: 1,
      Title: "Test Noti",
      Message: "Something, something, dark side",
      When: time.Now().AddDate(0, 0, -1),
      Created: time.Now(),
    },
  }

  return notifications, nil
}

// httpGetNotifications :
//
//
func httpGetNotifications(w http.ResponseWriter, r *http.Request) {
  InitResponse(&w)

  if r.Method == "OPTIONS" {return}
}

// getNotification :
//
//
func getNotification(w http.ResponseWriter, r *http.Request) {

}

// createNotification :
//
//
func createNotification(w http.ResponseWriter, r *http.Request) {

}

