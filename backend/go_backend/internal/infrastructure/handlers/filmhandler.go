package handlers

import (
	"fmt"
	"go_backend/internal/domain"
	"go_backend/internal/infrastructure/usecases"
	"net/http"

	"github.com/gin-gonic/gin"
)

type FilmHandler struct {
	filmUseCase *usecases.FilmUseCases
}

func NewFilmHandler(filmUseCase *usecases.FilmUseCases) *FilmHandler {
	return &FilmHandler{filmUseCase: filmUseCase}
}

func (fh *FilmHandler) AddFilm(c *gin.Context) {
	var (
		film         domain.RequestFilmModel
		returnedFilm *domain.ResponseFilmModel
	)

	if err := c.ShouldBindJSON(&film); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	returnedFilm, err := fh.filmUseCase.AddFilm(&film)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, returnedFilm)
}

func (fh *FilmHandler) DeleteFilm(c *gin.Context) {
	var film *domain.RequestDeleteFilmModel

	if err := c.ShouldBindJSON(&film); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	returnedFilm, err := fh.filmUseCase.DeleteFilm(film)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, returnedFilm)
}

func (fh *FilmHandler) GetFilm(c *gin.Context) {
	var film domain.RequestGetFilmModel

	if err := c.ShouldBindJSON(&film); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	returnedFilm, err := fh.filmUseCase.GetFilmByKey(&film)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, returnedFilm)
}

func (fh *FilmHandler) GetFilms(c *gin.Context) {
	var (
		film domain.RequestGetFilmsModel
	)
	fmt.Println("OK")
	if err := c.ShouldBindJSON(&film); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	returnedFilms, err := fh.filmUseCase.GetFilmsByUserID(&film)
	if err != nil {
		//if errors.As(err, &sql.ErrNoRows) {
		//	c.JSON(http.StatusOK, make([]domain.ResponseFilmModel, 0))
		//	return
		//}
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, returnedFilms)
}
