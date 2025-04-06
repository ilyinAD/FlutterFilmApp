package repository

import (
	"database/sql"
	"fmt"
	"go_backend/internal/domain/filmmodel"
)

type FilmRepository struct {
	db *sql.DB
}

func NewFilmRepository(db *sql.DB) *FilmRepository {
	return &FilmRepository{db: db}
}

func (fr *FilmRepository) GetFilmByKey(film *filmmodel.RequestGetFilmModel) (*filmmodel.ResponseFilmModel, error) {
	var returnedFilm filmmodel.ResponseFilmModel

	err := fr.db.QueryRow(`select id, picture, name, rating, description, film_url from film where film.id = $1
      `, film.ID).Scan(&returnedFilm.ID, &returnedFilm.Picture, &returnedFilm.Name,
		&returnedFilm.Rating, &returnedFilm.Description, &returnedFilm.FilmURL)
	if err != nil {
		return nil, fmt.Errorf("db: query: %w", err)
	}

	return &returnedFilm, nil
}

func (fr *FilmRepository) AddFilm(film *filmmodel.RequestFilmModel) (*filmmodel.ResponseFilmModel, error) {
	var returnedFilm filmmodel.ResponseFilmModel

	err := fr.db.QueryRow(`insert into film
values ($1, $2, $3, $4, $5, $6) returning id, picture, name, rating, description, film_url
      `, film.ID, film.Picture, film.Name, film.Rating, film.Description, film.FilmURL).Scan(
		&returnedFilm.ID, &returnedFilm.Picture, &returnedFilm.Name, &returnedFilm.Rating,
		&returnedFilm.Description, &returnedFilm.FilmURL)
	if err != nil {
		return nil, fmt.Errorf("db: query: %w", err)
	}

	return &returnedFilm, nil
}

func (fr *FilmRepository) DeleteFilm(filmReq *filmmodel.RequestDeleteFilmModel) (*filmmodel.ResponseFilmModel, error) {
	var (
		returnedFilm filmmodel.ResponseFilmModel
	)

	err := fr.db.QueryRow(`delete from film where id = $1 returning id, picture, name, rating, description, film_url
      `, filmReq.ID).Scan(&returnedFilm.ID, &returnedFilm.Picture, &returnedFilm.Name,
		&returnedFilm.Rating, &returnedFilm.Description, &returnedFilm.FilmURL)
	if err != nil {
		return nil, fmt.Errorf("db: query: %w", err)
	}

	return &returnedFilm, nil
}

func (fr *FilmRepository) UpdateFilm(film *filmmodel.RequestFilmModel) (*filmmodel.ResponseFilmModel, error) {
	var (
		returnedFilm filmmodel.ResponseFilmModel
	)

	err := fr.db.QueryRow(`update film set picture = $1, name = $2, rating = $3, description = $4,
              film_url = $5 where id = $6 returning id,
                  picture, name, rating, description, film_url
     `, film.Picture, film.Name, film.Rating, film.Description, film.FilmURL, film.ID).Scan(
		&returnedFilm.ID, &returnedFilm.Picture, &returnedFilm.Name, &returnedFilm.Rating,
		&returnedFilm.Description, &returnedFilm.FilmURL)
	if err != nil {
		return nil, fmt.Errorf("db: query: %w", err)
	}

	return &returnedFilm, nil
}

//func (fr *FilmRepository) GetFilmsByUserID(filmmodel *domain.RequestGetFilmsModel) ([]*domain.ResponseFilmModel, error) {
//	var returnedFilms []*domain.ResponseFilmModel
//
//	rows, err := fr.db.Query("select user_id, id, picture, name, rating, description, status, user_description, user_rating, film_url, added_at, viewed_at from filmmodel where filmmodel.user_id = $1",
//		filmmodel.UserID)
//	if err != nil {
//		return nil, fmt.Errorf("db: query: %w", err)
//	}
//
//	defer func(rows *sql.Rows) {
//		cErr := rows.Close()
//		if cErr != nil {
//			if err != nil {
//				err = cErr
//			}
//
//			err = errors.Join(err, cErr)
//		}
//	}(rows)
//
//	//var userRating sql.NullFloat64
//
//	for rows.Next() {
//		var returnedFilm domain.ResponseFilmModel
//		err = rows.Scan(&returnedFilm.UserID, &returnedFilm.ID, &returnedFilm.Picture, &returnedFilm.Name, &returnedFilm.Rating,
//			&returnedFilm.Description, &returnedFilm.Status, &returnedFilm.UserDescription, &returnedFilm.UserRating, &returnedFilm.FilmURL,
//			&returnedFilm.AddedAt, &returnedFilm.ViewedAt)
//		//if userRating.Valid {
//		//	returnedFilm.UserRating = &userRating.Float64
//		//}
//		if err != nil {
//			return nil, fmt.Errorf("db: scan: %w", err)
//		}
//
//		returnedFilms = append(returnedFilms, &returnedFilm)
//	}
//
//	return returnedFilms, nil
//}
