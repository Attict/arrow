package main

import (
  "flag"
  "fmt"
  "log"
  "net/http"
  "os"
  "strings"

  "github.com/gorilla/mux"

  "../.arrow/modules/core_module/server"
  "../.arrow/modules/dnd_module/server"

)

///
/// main
///
///
func main() {
  var env string
  flag.StringVar(&env, "e", "production", "Environment")
  flag.Parse()
  os.Setenv("APP_ENV", env)

  router := mux.NewRouter()
  core_module.JwtKey = []byte("a9p3zff3435la!-djk")
  core_module.Environment = core_module.EnvironmentDevelopment // TODO: DELETE

  // Init modules
  core_module.Init(router)
  dnd_module.Init(router)

  http.Handle("/api/", router)
  http.Handle("/styles/", http.FileServer(http.Dir("./")))
  http.Handle("/images/", http.FileServer(http.Dir("./")))
  http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
    path := "./public" + r.RequestURI
    if _, err := os.Stat(path); err != nil {
      if strings.Contains(r.RequestURI, "admin") {
        path = "./public/admin/index.html"
      } else {
        path = "./public/index.html"
      }
    }
    http.ServeFile(w, r, path)
  });

  fmt.Printf("Running on localhost:8500")
  log.Fatal(http.ListenAndServe(":8500", nil))
}
