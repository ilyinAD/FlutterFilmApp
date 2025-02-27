package handlers

import (
	"errors"
	"go_backend/internal/domain"
	"go_backend/internal/infrastructure/myerrors"
	"go_backend/internal/infrastructure/usecases"
	"net/http"

	"github.com/gin-gonic/gin"
)

type UserHandler struct {
	userUseCase *usecases.UserUseCase
}

func NewUserHandler(userUseCase *usecases.UserUseCase) *UserHandler {
	return &UserHandler{userUseCase: userUseCase}
}

func (uh *UserHandler) RegisterUser(c *gin.Context) {
	var (
		user         domain.RequestUserModel
		returnedUser *domain.ResponseUserModel
	)

	if err := c.ShouldBindJSON(&user); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})

		return
	}

	returnedUser, err := uh.userUseCase.RegisterUser(&user)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})

		return
	}

	c.JSON(http.StatusOK, returnedUser)
}

func (uh *UserHandler) LoginUser(c *gin.Context) {
	var (
		user         domain.RequestUserModel
		returnedUser *domain.ResponseUserModel
	)

	if err := c.ShouldBindJSON(&user); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	returnedUser, err := uh.userUseCase.LoginUser(&user)
	if err != nil {
		var (
			errNoUser    myerrors.ErrNoUser
			errWrongPass myerrors.ErrWrongPass
		)

		if errors.As(err, &errNoUser) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		} else if errors.As(err, &errWrongPass) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}

		return
	}

	c.JSON(http.StatusOK, returnedUser)
}
