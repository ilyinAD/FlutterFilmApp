package usecases

import (
	"database/sql"
	"errors"
	"fmt"
	"go_backend/internal/domain"
	"go_backend/internal/infrastructure/repository"
)

type FilmUseCases struct {
	filmRepository *repository.FilmRepository
}

func NewFilmUseCases(filmRepository *repository.FilmRepository) *FilmUseCases {
	return &FilmUseCases{filmRepository: filmRepository}
}

func (uc *FilmUseCases) AddFilm(film *domain.RequestFilmModel) (*domain.ResponseFilmModel, error) {
	isExist := 0

	_, err := uc.filmRepository.GetFilmByKey(&domain.RequestGetFilmModel{
		ID:     film.ID,
		UserID: film.UserID,
	})
	if err != nil {
		if errors.As(err, &sql.ErrNoRows) {
			isExist = 1
		} else {
			return nil, fmt.Errorf("error while getting film from database: %v", err)
		}
	}

	if isExist == 1 {
		return uc.filmRepository.AddFilm(film)
	} else {
		return uc.filmRepository.UpdateFilm(film)
	}
}

func (uc *FilmUseCases) DeleteFilm(film *domain.RequestDeleteFilmModel) (*domain.ResponseFilmModel, error) {
	return uc.filmRepository.DeleteFilm(film)
}

func (uc *FilmUseCases) GetFilmByKey(film *domain.RequestGetFilmModel) (*domain.ResponseFilmModel, error) {
	return uc.filmRepository.GetFilmByKey(film)
}

func (uc *FilmUseCases) GetFilmsByUserID(film *domain.RequestGetFilmsModel) ([]*domain.ResponseFilmModel, error) {
	return uc.filmRepository.GetFilmsByUserID(film)
}
