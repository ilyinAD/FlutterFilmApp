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
	if res, _ := uc.userRepository.GetUserByLogin(user.Username); res != nil {
		return nil, myerrors.ErrExists{Msg: "login"}
	}

	if res, _ := uc.userRepository.GetUserByEmail(user.Email); res != nil {
		return nil, myerrors.ErrExists{Msg: "email"}
	}

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
			return nil, myerrors.ErrWrongPassOrNoUser{}
		} else {
			return nil, fmt.Errorf("error while logging in: %v", err)
		}
	}

	err = bcrypt.CompareHashAndPassword([]byte(returnedUser.Password), []byte(user.Password))
	if err != nil {
		return nil, myerrors.ErrWrongPassOrNoUser{}
	}

	return returnedUser, nil
}

func (uc *UserUseCase) GetUser(id int) (*domain.ResponseUserModel, error) {
	return uc.userRepository.GetUserByID(id)
}
