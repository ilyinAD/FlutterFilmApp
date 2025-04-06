package repository

import (
	"database/sql"
	"fmt"
	"go_backend/internal/domain/userfilminfomodel"
)

type UserFilmInfoRepository struct {
	db *sql.DB
}

func NewUserFilmInfoRepository(db *sql.DB) *UserFilmInfoRepository {
	return &UserFilmInfoRepository{db: db}
}

func (ur *UserFilmInfoRepository) GetUserByKey(userInfo *userfilminfomodel.RequestGetUserInfoModel) (*userfilminfomodel.ResponseUserFilmInfoModel, error) {
	var returnedUserInfo userfilminfomodel.ResponseUserFilmInfoModel

	err := ur.db.QueryRow("select user_id, film_id, user_description, user_rating, added_at, viewed_at, status from user_film_info where user_id = $1 and film_id = $2", userInfo.UserID, userInfo.FilmID).Scan(
		&returnedUserInfo.UserID, &returnedUserInfo.FilmID, &returnedUserInfo.UserDescription, &returnedUserInfo.UserRating,
		&returnedUserInfo.AddedAt, &returnedUserInfo.ViewedAt, &returnedUserInfo.Status)
	if err != nil {
		return nil, fmt.Errorf("error getting usermodel info: %v", err)
	}

	return &returnedUserInfo, nil
}

func (ur *UserFilmInfoRepository) AddUserInfo(userInfo *userfilminfomodel.RequestAddUserInfoModel) (*userfilminfomodel.ResponseUserFilmInfoModel, error) {
	var returnedUserInfo userfilminfomodel.ResponseUserFilmInfoModel

	err := ur.db.QueryRow("insert into user_film_info values ($1, $2, $3, $4, $5, $6, $7) returning user_id, film_id, user_description, user_rating, added_at, viewed_at, status",
		userInfo.UserID, userInfo.FilmID, userInfo.UserDescription, userInfo.UserRating, userInfo.AddedAt, userInfo.ViewedAt, userInfo.Status).Scan(
		&returnedUserInfo.UserID, &returnedUserInfo.FilmID, &returnedUserInfo.UserDescription, &returnedUserInfo.UserRating,
		&returnedUserInfo.AddedAt, &returnedUserInfo.ViewedAt, &returnedUserInfo.Status)
	if err != nil {
		return nil, fmt.Errorf("error adding usermodel info: %w", err)
	}

	return &returnedUserInfo, nil
}

func (ur *UserFilmInfoRepository) UpdateUserInfo(userInfo *userfilminfomodel.RequestAddUserInfoModel) (*userfilminfomodel.ResponseUserFilmInfoModel, error) {
	var returnedUserInfo userfilminfomodel.ResponseUserFilmInfoModel

	err := ur.db.QueryRow("update user_film_info set user_description = $1, user_rating = $2, added_at = $3, viewed_at = $4, status = $5 where user_id = $6 and film_id = $7 returning user_id, film_id, user_description, user_rating, added_at, viewed_at, status",
		userInfo.UserDescription, userInfo.UserRating, userInfo.AddedAt, userInfo.ViewedAt, userInfo.Status, userInfo.UserID, userInfo.FilmID).Scan(
		&returnedUserInfo.UserID, &returnedUserInfo.FilmID, &returnedUserInfo.UserDescription, &returnedUserInfo.UserRating,
		&returnedUserInfo.AddedAt, &returnedUserInfo.ViewedAt, &returnedUserInfo.Status)
	if err != nil {
		return nil, fmt.Errorf("error updating usermodel info: %w", err)
	}

	return &returnedUserInfo, nil
}

func (ur *UserFilmInfoRepository) DeleteUserInfo(userInfo *userfilminfomodel.RequestDeleteInfoModel) (*userfilminfomodel.ResponseUserFilmInfoModel, error) {
	var returnedUserInfo userfilminfomodel.ResponseUserFilmInfoModel

	err := ur.db.QueryRow("delete from user_film_info where user_id = $1 and film_id = $2 returning user_id, film_id, user_description, user_rating, added_at, viewed_at, status",
		userInfo.UserID, userInfo.ID).Scan(&returnedUserInfo.UserID, &returnedUserInfo.FilmID, &returnedUserInfo.UserDescription, &returnedUserInfo.UserRating,
		&returnedUserInfo.AddedAt, &returnedUserInfo.ViewedAt, &returnedUserInfo.Status)
	if err != nil {
		return nil, fmt.Errorf("error deleting usermodel info: %w", err)
	}

	return &returnedUserInfo, nil
}

func (ur *UserFilmInfoRepository) GetFilmsByUserID(userInfo *userfilminfomodel.RequestGetUserInfoModels) ([]*userfilminfomodel.ResponseUserFilmInfoModel, error) {
	var returnedUsersInfo []*userfilminfomodel.ResponseUserFilmInfoModel

	rows, err := ur.db.Query("select user_id, film_id, user_description, user_rating, added_at, viewed_at, status from user_film_info where user_id = $1", userInfo.UserID)
	if err != nil {
		return nil, fmt.Errorf("error getting usermodel info: %w", err)
	}

	defer rows.Close()

	for rows.Next() {
		var returnedUserInfo userfilminfomodel.ResponseUserFilmInfoModel

		err = rows.Scan(&returnedUserInfo.UserID, &returnedUserInfo.FilmID, &returnedUserInfo.UserDescription, &returnedUserInfo.UserRating,
			&returnedUserInfo.AddedAt, &returnedUserInfo.ViewedAt, &returnedUserInfo.Status)
		if err != nil {
			return nil, fmt.Errorf("error getting usermodel info: %w", err)
		}

		returnedUsersInfo = append(returnedUsersInfo, &returnedUserInfo)
	}

	return returnedUsersInfo, nil
}
