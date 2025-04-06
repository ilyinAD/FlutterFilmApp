package repository

import (
	"database/sql"
	"fmt"
	"go_backend/internal/domain/usermodel"
)

type UserRepository struct {
	db *sql.DB
}

func NewUserRepository(db *sql.DB) *UserRepository {
	return &UserRepository{db: db}
}

func (ur *UserRepository) AddUser(user *usermodel.RequestUserModel) (*usermodel.ResponseUserModel, error) {
	var returnedUser usermodel.ResponseUserModel

	err := ur.db.QueryRow("INSERT INTO users (username, password, email) VALUES ($1, $2, $3) RETURNING  users.id, users.username, users.email, users.password",
		user.Username, user.Password, user.Email).Scan(&returnedUser.ID, &returnedUser.Username, &returnedUser.Email, &returnedUser.Password)
	if err != nil {
		return nil, fmt.Errorf("db: query: %w", err)
	}

	return &returnedUser, nil
}

func (ur *UserRepository) GetUserByLogin(username string) (*usermodel.ResponseUserModel, error) {
	var returnedUser usermodel.ResponseUserModel

	err := ur.db.QueryRow(`
            SELECT id, username, password, email
            FROM users
            WHERE username = $1
        `, username).Scan(&returnedUser.ID, &returnedUser.Username, &returnedUser.Password, &returnedUser.Email)
	if err != nil {
		return nil, fmt.Errorf("db: query: %w", err)
	}

	return &returnedUser, nil
}

func (ur *UserRepository) GetUserByEmail(email string) (*usermodel.ResponseUserModel, error) {
	var returnedUser usermodel.ResponseUserModel
	err := ur.db.QueryRow("SELECT id, username, password, email FROM users WHERE email = $1", email).Scan(&returnedUser.ID, &returnedUser.Username, &returnedUser.Password, &returnedUser.Email)
	if err != nil {
		return nil, fmt.Errorf("db: query: %w", err)
	}

	return &returnedUser, nil
}

func (ur *UserRepository) GetUserByID(id int) (*usermodel.ResponseUserModel, error) {
	var returnedUser usermodel.ResponseUserModel
	err := ur.db.QueryRow("SELECT id, username, password, email FROM users WHERE users.id = $1", id).Scan(&returnedUser.ID, &returnedUser.Username, &returnedUser.Password, &returnedUser.Email)
	if err != nil {
		return nil, fmt.Errorf("db: query: %w", err)
	}

	return &returnedUser, nil
}
