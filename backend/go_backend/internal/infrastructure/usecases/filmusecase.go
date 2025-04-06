package usecases

import (
	"database/sql"
	"errors"
	"fmt"
	"go_backend/internal/domain"
	"go_backend/internal/domain/filmmodel"
	"go_backend/internal/domain/userfilminfomodel"
	"go_backend/internal/infrastructure/repository"
)

type FilmUseCases struct {
	filmRepository         *repository.FilmRepository
	userFilmInfoRepository *repository.UserFilmInfoRepository
}

func NewFilmUseCases(filmRepository *repository.FilmRepository, userFilmInfoRepository *repository.UserFilmInfoRepository) *FilmUseCases {
	return &FilmUseCases{filmRepository: filmRepository, userFilmInfoRepository: userFilmInfoRepository}
}

func (uc *FilmUseCases) AddFilm(film *domain.RequestGetUnionModel) (*domain.ResponseUnionModel, error) {
	isExist := 0

	_, err := uc.filmRepository.GetFilmByKey(&filmmodel.RequestGetFilmModel{ID: film.ID})
	if err != nil {
		if errors.As(err, &sql.ErrNoRows) {
			isExist = 1
		} else {
			return nil, fmt.Errorf("error while getting filmmodel from database: %v", err)
		}
	}

	filmModel := &filmmodel.RequestFilmModel{
		ID:          film.ID,
		Picture:     film.Picture,
		Name:        film.Name,
		Rating:      film.Rating,
		Description: film.Description,
		FilmURL:     film.FilmURL,
	}

	var (
		returnedFilmModel     *filmmodel.ResponseFilmModel
		returnedUserInfoModel *userfilminfomodel.ResponseUserFilmInfoModel
	)

	if isExist == 1 {
		returnedFilmModel, err = uc.filmRepository.AddFilm(filmModel)
	} else {
		returnedFilmModel, err = uc.filmRepository.UpdateFilm(filmModel)
	}

	if err != nil {
		return nil, fmt.Errorf("error while adding film: %v", err)
	}

	isExist = 0

	_, err = uc.userFilmInfoRepository.GetUserByKey(&userfilminfomodel.RequestGetUserInfoModel{
		UserID: film.UserID,
		FilmID: film.ID,
	})
	if err != nil {
		if errors.As(err, &sql.ErrNoRows) {
			isExist = 1
		} else {
			return nil, fmt.Errorf("error while getting filmmodel from database: %v", err)
		}
	}

	userInfoModel := &userfilminfomodel.RequestAddUserInfoModel{
		UserID:          film.UserID,
		FilmID:          film.ID,
		UserDescription: film.UserDescription,
		UserRating:      film.UserRating,
		AddedAt:         film.AddedAt,
		ViewedAt:        film.ViewedAt,
		Status:          film.Status,
	}

	if isExist == 1 {
		returnedUserInfoModel, err = uc.userFilmInfoRepository.AddUserInfo(userInfoModel)
	} else {
		returnedUserInfoModel, err = uc.userFilmInfoRepository.UpdateUserInfo(userInfoModel)
	}

	if err != nil {
		return nil, fmt.Errorf("error while adding film: %v", err)
	}

	return &domain.ResponseUnionModel{
		UserID:          returnedUserInfoModel.UserID,
		ID:              returnedFilmModel.ID,
		Picture:         returnedFilmModel.Picture,
		Name:            returnedFilmModel.Name,
		Rating:          returnedFilmModel.Rating,
		Description:     returnedFilmModel.Description,
		Status:          returnedUserInfoModel.Status,
		UserDescription: returnedUserInfoModel.UserDescription,
		UserRating:      returnedUserInfoModel.UserRating,
		FilmURL:         returnedFilmModel.FilmURL,
		AddedAt:         returnedUserInfoModel.AddedAt,
		ViewedAt:        returnedUserInfoModel.ViewedAt,
	}, nil
}

func (uc *FilmUseCases) DeleteFilm(film *userfilminfomodel.RequestDeleteInfoModel) (*domain.ResponseUnionModel, error) {
	returnedUserInfoModel, err := uc.userFilmInfoRepository.DeleteUserInfo(film)
	if err != nil {
		return nil, fmt.Errorf("error while deleting film: %v", err)
	}

	returnedFilmModel, err := uc.filmRepository.GetFilmByKey(&filmmodel.RequestGetFilmModel{ID: film.ID})
	if err != nil {
		return nil, fmt.Errorf("error while getting filmmodel from database: %v", err)
	}

	return &domain.ResponseUnionModel{
		UserID:          returnedUserInfoModel.UserID,
		ID:              returnedFilmModel.ID,
		Picture:         returnedFilmModel.Picture,
		Name:            returnedFilmModel.Name,
		Rating:          returnedFilmModel.Rating,
		Description:     returnedFilmModel.Description,
		Status:          returnedUserInfoModel.Status,
		UserDescription: returnedUserInfoModel.UserDescription,
		UserRating:      returnedUserInfoModel.UserRating,
		FilmURL:         returnedFilmModel.FilmURL,
		AddedAt:         returnedUserInfoModel.AddedAt,
		ViewedAt:        returnedUserInfoModel.ViewedAt,
	}, nil
}

func (uc *FilmUseCases) GetFilmByKey(film *userfilminfomodel.RequestGetUserInfoModel) (*domain.ResponseUnionModel, error) {
	returnedUserInfoModel, err := uc.userFilmInfoRepository.GetUserByKey(film)
	if err != nil {
		return nil, fmt.Errorf("userFilmInfoRepository: GetFilmByKey %w", err)
	}

	returnedFilmModel, err := uc.filmRepository.GetFilmByKey(&filmmodel.RequestGetFilmModel{ID: film.FilmID})
	if err != nil {
		return nil, fmt.Errorf("error while getting filmmodel from database: %v", err)
	}

	return &domain.ResponseUnionModel{
		UserID:          returnedUserInfoModel.UserID,
		ID:              returnedFilmModel.ID,
		Picture:         returnedFilmModel.Picture,
		Name:            returnedFilmModel.Name,
		Rating:          returnedFilmModel.Rating,
		Description:     returnedFilmModel.Description,
		Status:          returnedUserInfoModel.Status,
		UserDescription: returnedUserInfoModel.UserDescription,
		UserRating:      returnedUserInfoModel.UserRating,
		FilmURL:         returnedFilmModel.FilmURL,
		AddedAt:         returnedUserInfoModel.AddedAt,
		ViewedAt:        returnedUserInfoModel.ViewedAt,
	}, nil
}

func (uc *FilmUseCases) GetFilmsByUserID(film *userfilminfomodel.RequestGetUserInfoModels) ([]*domain.ResponseUnionModel, error) {
	returnedUserInfoModels, err := uc.userFilmInfoRepository.GetFilmsByUserID(film)
	if err != nil {
		return nil, fmt.Errorf("error while getting filmRepository: %v", err)
	}

	var returnedResponses []*domain.ResponseUnionModel

	for _, returnedUserInfoModel := range returnedUserInfoModels {
		returnedFilmModel, err := uc.filmRepository.GetFilmByKey(&filmmodel.RequestGetFilmModel{ID: returnedUserInfoModel.FilmID})
		if err != nil {
			return nil, fmt.Errorf("error while getting filmmodel from database: %v", err)
		}

		returnedResponses = append(returnedResponses, &domain.ResponseUnionModel{UserID: returnedUserInfoModel.UserID,
			ID:              returnedFilmModel.ID,
			Picture:         returnedFilmModel.Picture,
			Name:            returnedFilmModel.Name,
			Rating:          returnedFilmModel.Rating,
			Description:     returnedFilmModel.Description,
			Status:          returnedUserInfoModel.Status,
			UserDescription: returnedUserInfoModel.UserDescription,
			UserRating:      returnedUserInfoModel.UserRating,
			FilmURL:         returnedFilmModel.FilmURL,
			AddedAt:         returnedUserInfoModel.AddedAt,
			ViewedAt:        returnedUserInfoModel.ViewedAt})
	}

	return returnedResponses, nil
}
