package usecases

import (
	"database/sql"
	"errors"
	"fmt"
	"go_backend/internal/domain"
	"go_backend/internal/infrastructure/myerrors"
	"go_backend/internal/infrastructure/repository"

	"golang.org/x/crypto/bcrypt"
)

type UserUseCase struct {
	userRepository *repository.UserRepository
}

func NewUserUseCase(userRepository *repository.UserRepository) *UserUseCase {
	return &UserUseCase{userRepository: userRepository}
}

func (uc *UserUseCase) RegisterUser(user *domain.RequestUserModel) (*domain.ResponseUserModel, error) {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, fmt.Errorf("error while hashing password: %v", err)
	}

	user.Password = string(hashedPassword)

	return uc.userRepository.AddUser(user)
}

func (uc *UserUseCase) LoginUser(user *domain.RequestUserModel) (*domain.ResponseUserModel, error) {
	returnedUser, err := uc.userRepository.GetUserByLogin(user.Username)
	if err != nil {
		if errors.As(err, &sql.ErrNoRows) {
			return nil, myerrors.ErrNoUser{Msg: user.Username}
		} else {
			return nil, fmt.Errorf("error while logging in: %v", err)
		}
	}

	err = bcrypt.CompareHashAndPassword([]byte(returnedUser.Password), []byte(user.Password))
	if err != nil {
		return nil, myerrors.ErrWrongPass{Msg: returnedUser.Username}
	}

	return returnedUser, nil
}
