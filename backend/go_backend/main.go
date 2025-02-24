package main

import (
	"database/sql"
	"errors"
	"fmt"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
	"golang.org/x/crypto/bcrypt"
)

var db *sql.DB

func initDB() {
	var err error
	connStr := "user=postgres password=postgres dbname=mydatabase sslmode=disable"

	db, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal("Error opening database: ", err)
	}

	if err = db.Ping(); err != nil {
		log.Fatal("Error connecting to database: ", err)
	}
}

type User struct {
	Username string `json:"username"`
	Password string `json:"password"`
	Email    string `json:"email"`
}

func registerUser(c *gin.Context) {
	var (
		user         User
		returnedUser User
		userID       int
	)

	if err := c.ShouldBindJSON(&user); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Не удалось захэшировать пароль"})
		return
	}

	err = db.QueryRow("INSERT INTO users (username, password, email) VALUES ($1, $2, $3) RETURNING  users.id, users.username, users.email",
		user.Username, string(hashedPassword), user.Email).Scan(&userID, &returnedUser.Username, &returnedUser.Email)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Данный логин уже существует"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "User registered successfully", "id": userID,
		"username": returnedUser.Username, "email": returnedUser.Email})
}

func loginUser(c *gin.Context) {
	var (
		user         User
		returnedUser User
		userID       int
	)

	if err := c.ShouldBindJSON(&user); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := db.QueryRow(`
            SELECT id, username, password, email
            FROM users
            WHERE username = $1
        `, user.Username).Scan(&userID, &returnedUser.Username, &returnedUser.Password, &returnedUser.Email)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Пользователь не найден"})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при запросе"})
		}
		return
	}

	err = bcrypt.CompareHashAndPassword([]byte(returnedUser.Password), []byte(user.Password))
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Неверный пароль"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "User logged in", "id": userID, "username": returnedUser.Username,
		"email": returnedUser.Email})

}

type FilmModel struct {
	UserID      int     `json:"userID"`
	ID          int     `json:"id"`
	Picture     string  `json:"picture"`
	Name        string  `json:"name"`
	Rating      float32 `json:"rating"`
	Description string  `json:"description"`
	Status      int     `json:"status"`
}

func addFilm(c *gin.Context) {
	var (
		film         FilmModel
		returnedFilm FilmModel
	)

	if err := c.ShouldBindJSON(&film); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := db.QueryRow(`insert into film
values ($1, $2, $3, $4, $5, $6, $7) returning film.user_id, film.id, film.name
        `, film.UserID, film.ID, film.Picture, film.Name, film.Rating, film.Description, film.Status).Scan(&returnedFilm.UserID, &returnedFilm.ID, &returnedFilm.Name)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "Film added", "id": returnedFilm.ID, "user_id": returnedFilm.UserID, "name": returnedFilm.Name})
}

func main() {
	initDB()
	defer func(db *sql.DB) {
		err := db.Close()
		if err != nil {
			fmt.Println("Error closing DB: ", err)
		}
	}(db)

	r := gin.Default()

	r.POST("/register", registerUser)
	r.POST("/login", loginUser)
	r.POST("/addFilm", addFilm)

	err := r.Run(":8080")
	if err != nil {
		fmt.Println("Error running server: ", err)
	}
}
