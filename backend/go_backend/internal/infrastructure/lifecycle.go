package infrastructure

import (
	"database/sql"
	"fmt"
	"go_backend/internal/infrastructure/handlers"
	"log"

	"github.com/gin-gonic/gin"
)

func InitDB() (*sql.DB, error) {
	var err error
	connStr := "user=postgres password=postgres dbname=mydatabase sslmode=disable"

	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return nil, fmt.Errorf("error sql.Open: %w", err)
	}

	if err = db.Ping(); err != nil {
		return nil, fmt.Errorf("error ping: %w", err)
	}

	return db, nil
}

func NewEngine(handlers *handlers.Handlers) *gin.Engine {
	r := gin.Default()

	r.POST("/register", handlers.UserHandler.RegisterUser)
	r.POST("/login", handlers.UserHandler.LoginUser)
	r.POST("/addFilm", handlers.FilmHandler.AddFilm)
	r.DELETE("/deleteFilm", handlers.FilmHandler.DeleteFilm)
	r.GET("/getFilm", handlers.FilmHandler.GetFilm)
	r.GET("/getFilms", handlers.FilmHandler.GetFilms)

	return r
}

func StartServer(r *gin.Engine) {
	db, err := InitDB()
	if err != nil {
		log.Fatal(err)
	}

	defer func(db *sql.DB) {
		err := db.Close()
		if err != nil {
			fmt.Println("Error closing DB: ", err)
		}
	}(db)

	err = r.Run(":8080")
	if err != nil {
		fmt.Println("Error running server: ", err)
	}
}
