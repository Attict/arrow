package core_module

import (
  "log"
  "net/http"

  "github.com/gorilla/mux"
  "github.com/gorilla/websocket"
)

// Hubs : Websocket connections are stored through this array of CoreHub
// objects.  Each module should have it's own hub by map.
//
var hubs map[uint]*CoreHub

// upgrader : Upgrades the websocket
//
//
var upgrader = websocket.Upgrader{
  ReadBufferSize: 1024,
  WriteBufferSize: 1024,
}

// CoreHub : Sockets are connected to a hub, which can then handle
// actions and updated clients by hub.
//
type CoreHub struct {
  // Registered clients.
  Clients       map[*CoreClient]bool

  // Inbound messages from clients.
  Broadcast     chan []byte

  // Register requests from the clients.
  Register      chan *CoreClient

  // Unregister requests from clients.
  Unregister    chan *CoreClient
}

// CoreClient : Socket connected client
//
//
type CoreClient struct {
  Hub       *CoreHub
  Conn      *websocket.Conn
  Send      chan []byte
  ModuleID  uint
}

func initSocket(router *mux.Router) {
  if Environment != EnvironmentProduction {
    upgrader.CheckOrigin = func(r *http.Request) bool { return true }
  }
  router.HandleFunc("/api/socket", handleSocket)
}

// handleSocket : WebSocket for live data, which should fallback http if
// needed.
//
func handleSocket(w http.ResponseWriter, r *http.Request) {
  log.Print("Socket")
  c, err := upgrader.Upgrade(w, r, nil)
  if err != nil {
    log.Print("upgrade:", err)
    return
  }
  defer c.Close()

  for {
    _, message, err := c.ReadMessage()
    if err != nil {
      log.Println("read:", err)
      break
    }
    log.Printf("recv: %s", message)

    notifications, _ := getNotifications(0);

    //err = c.WriteMessage(mt, message)
    err = c.WriteJSON(notifications)
    if err != nil {
      log.Println("write:", err)
      break
    }
  }
}
