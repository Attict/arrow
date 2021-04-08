package blog_module

import (
	"encoding/json"
    "fmt"
	"net/http"
    "os"
    "io"
	"strconv"
	"time"


	"github.com/gorilla/mux"
    core_module "../../core_module/server"
)

var BlogModuleID uint

// Blog Model
type Blog struct {
	ID         uint                     `json:"id"`
	Title      string                   `json:"title"`
	Body       string                   `json:"body"`
	Brief      string                   `json:"brief"`
	AuthorID   uint                     `json:"authorId"`
    Author     *core_module.CoreUser    `json:"author"     pg:"has1:core_users"`
	Created    time.Time                `json:"created"`
	Modified   time.Time                `json:"modified"   sql:",nullable"`
	Tags       []BlogTag                `json:"tags"       sql:",nullable"`
    CoverImage string                   `json:"coverImage" sql:",nullable"`
}

// BlogTag Model
type BlogTag struct {
	ID    uint   `json:"id"`
	Label string `json:"label"`
}


func Init(router *mux.Router) {
  // Insert the module into CoreModules
  BlogModuleID = core_module.AddModule("Blog Module", 0)
  core_module.SetPermission(core_module.CorePermission{
    ModuleID: BlogModuleID,
    Read: core_module.CorePermissionAll,
  })

  // Model
  model := (*Blog)(nil)
  core_module.AddModel(model)
  core_module.InsertInitialModel(
    model,
    &Blog{
      Title:    "First Blog Post",
      Body:     "Hello, World!  Welcome to the first blog post." +
        "This is some really long text.  This needs plenty of space.<br><br>" +
        "More text in a different paragraph.<br><br>" +
        "And another paragraph with more text. " +
        "Some more text bla bla bla.<br>",
      Brief:    "A brief description that will appear on the homepage.",
      AuthorID: 1,
      Created:  time.Now(),
    },
    &Blog{
      Title:    "Highlight Blog Post",
      Body:     "Hello, World!  Welcome to the highlight blog post." +
        "This is some really long text.  This needs plenty of space.<br><br>" +
        "More text in a different paragraph.<br><br>" +
        "And another paragraph with more text. " +
        "Some more text bla bla bla.<br>",
      Brief:    "A brief description that will appear on the homepage.",
      AuthorID: 1,
      Created:  time.Now(),
    },
  )

  router.HandleFunc("/api/blogs", getBlogs).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/blogs/{id}", getBlog).Methods("GET", "OPTIONS")
  router.HandleFunc("/api/blogs", createBlog).Methods("POST", "OPTIONS")
  router.HandleFunc("/api/blogs", updateBlog).Methods("PUT", "OPTIONS")
  router.HandleFunc("/api/blogs/{id}", deleteBlog).Methods("DELETE", "OPTIONS")
}

//
//
//
func getBlogs(w http.ResponseWriter, r *http.Request) {
  core_module.InitResponse(&w)

  if r.Method == "OPTIONS" {return}

  allow, _ := core_module.HasPermission(
    &w,
    r,
    BlogModuleID,
    core_module.CoreAccessRead,
  )
  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    return
  }

  var blogs []Blog

  err := core_module.Db.
    Model(&blogs).
    Relation("Author").
    Relation("Author.Group").
    Order("created DESC").
    Select()
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    return
  }

  w.WriteHeader(http.StatusOK)
  json.NewEncoder(w).Encode(blogs)
}

//
//
//
func getBlog(w http.ResponseWriter, r *http.Request) {
  core_module.InitResponse(&w)

  if r.Method == "OPTIONS" {return}

  allow, _ := core_module.HasPermission(
    &w,
    r,
    BlogModuleID,
    core_module.CoreAccessRead,
  )
  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    return
  }

  params := mux.Vars(r)
  idParam, _ := strconv.ParseUint(params["id"], 10, 16)

  blog := &Blog{
    ID: uint(idParam),
  }

  err := core_module.Db.
    Model(blog).
    Relation("Author.username").
    WherePK().
    Select()
  if err != nil {
    w.WriteHeader(http.StatusNotFound)
    return
  }

  w.WriteHeader(http.StatusOK)
  json.NewEncoder(w).Encode(blog)
}

//
//
//
func createBlog(w http.ResponseWriter, r *http.Request) {
  core_module.InitResponse(&w)

  if r.Method == "OPTIONS" {return}

  allow, claims := core_module.HasPermission(
    &w,
    r,
    BlogModuleID,
    core_module.CoreAccessCreate,
  )
  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    return
  }

  file, header, err := r.FormFile("file")
  setCoverImage := err == nil
  if setCoverImage {defer file.Close()}

  var blog Blog
  err = json.Unmarshal([]byte(r.Form["blog"][0]), &blog)
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    return
  }

  if setCoverImage {blog.CoverImage = header.Filename}

  blog.AuthorID = claims.UserID
  blog.Created = time.Now()

  _, err = core_module.Db.Model(&blog).Returning("*").Insert()
  if err != nil {
    w.WriteHeader(http.StatusInternalServerError)
    return
  }

  if setCoverImage {
    dir := fmt.Sprintf("./media/blog/")
    if _, err := os.Stat(dir); os.IsNotExist(err) {
      os.MkdirAll(dir, 0755)
    }

    f, err := os.OpenFile(dir + header.Filename, os.O_WRONLY|os.O_CREATE, 0666)
    if err != nil {
      w.WriteHeader(http.StatusInternalServerError)
      return
    }
    defer f.Close()
    io.Copy(f, file)
  }

  w.WriteHeader(http.StatusAccepted)
}

func updateBlog(w http.ResponseWriter, r *http.Request) {
  core_module.InitResponse(&w)

  if r.Method == "OPTIONS" {return}

  allow, _ := core_module.HasPermission(
    &w,
    r,
    BlogModuleID,
    core_module.CoreAccessUpdate,
  )
  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    return
  }

  file, header, err := r.FormFile("file")
  setCoverImage := err == nil

  if setCoverImage {defer file.Close()}

  var blog Blog
  err = json.Unmarshal([]byte(r.Form["blog"][0]), &blog)
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    return
  }

  if setCoverImage {blog.CoverImage = header.Filename}

  blog.Modified = time.Now()

  _, err = core_module.Db.Model(&blog).
      Column("title", "brief", "body", "cover_image", "modified").
      WherePK().
      Returning("*").
      Relation("Author.username").
      Update()
  if err != nil {
    w.WriteHeader(http.StatusInternalServerError)
    return
  }

  if setCoverImage {
    dir := fmt.Sprintf("./media/blog/")
    if _, err := os.Stat(dir); os.IsNotExist(err) {
      os.MkdirAll(dir, 0755)
    }

    f, err := os.OpenFile(dir + header.Filename, os.O_WRONLY|os.O_CREATE, 0666)
    if err != nil {
      w.WriteHeader(http.StatusInternalServerError)
      return
    }
    defer f.Close()
    io.Copy(f, file)
  }

  w.WriteHeader(http.StatusAccepted)
}

func deleteBlog(w http.ResponseWriter, r *http.Request) {
  core_module.InitResponse(&w)

  if r.Method == "OPTIONS" {return}

  allow, _ := core_module.HasPermission(
    &w,
    r,
    BlogModuleID,
    core_module.CoreAccessDelete,
  )
  if !allow {
    w.WriteHeader(http.StatusUnauthorized)
    return
  }

  params := mux.Vars(r)
  id, _ := strconv.ParseUint(params["id"], 10, 16)

  blog := &Blog{ID: uint(id)}
  _, err := core_module.Db.Model(blog).WherePK().Returning("*").Delete()
  if err != nil {
    w.WriteHeader(http.StatusNotFound)
    return
  }

  w.WriteHeader(http.StatusAccepted)
}

