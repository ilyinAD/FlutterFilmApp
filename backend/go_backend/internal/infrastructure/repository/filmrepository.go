package repository

import (
	"database/sql"
	"errors"
	"fmt"
	"go_backend/internal/domain"
)

type FilmRepository struct {
	db *sql.DB
}

func NewFilmRepository(db *sql.DB) *FilmRepository {
	return &FilmRepository{db: db}
}

func (fr *FilmRepository) GetFilmByKey(film *domain.RequestGetFilmModel) (*domain.ResponseFilmModel, error) {
	var returnedFilm domain.ResponseFilmModel

	err := fr.db.QueryRow(`select user_id, id, picture, name, rating, description, status from film where film.id = $1 and film.user_id = $2
      `, film.ID, film.UserID).Scan(&returnedFilm.UserID, &returnedFilm.ID, &returnedFilm.Picture, &returnedFilm.Name, &returnedFilm.Rating, &returnedFilm.Description, &returnedFilm.Status)
	if err != nil {
		return nil, fmt.Errorf("db: query: %w", err)
	}

	return &returnedFilm, nil
}

func (fr *FilmRepository) AddFilm(film *domain.RequestFilmModel) (*domain.ResponseFilmModel, error) {
	var returnedFilm domain.ResponseFilmModel

	err := fr.db.QueryRow(`insert into film
values ($1, $2, $3, $4, $5, $6, $7) returning user_id, id, picture, name, rating, description, status
      `, film.UserID, film.ID, film.Picture, film.Name, film.Rating, film.Description, film.Status).Scan(&returnedFilm.UserID, &returnedFilm.ID, &returnedFilm.Picture, &returnedFilm.Name, &returnedFilm.Rating, &returnedFilm.Description, &returnedFilm.Status)
	if err != nil {
		return nil, fmt.Errorf("db: query: %w", err)
	}

	return &returnedFilm, nil
}

func (fr *FilmRepository) DeleteFilm(filmReq *domain.RequestDeleteFilmModel) (*domain.ResponseFilmModel, error) {
	var (
		returnedFilm domain.ResponseFilmModel
	)

	err := fr.db.QueryRow(`delete from film where id = $1 and user_id = $2 returning user_id, id, picture, name, rating, description, status
      `, filmReq.ID, filmReq.UserID).Scan(&returnedFilm.UserID, &returnedFilm.ID, &returnedFilm.Picture, &returnedFilm.Name, &returnedFilm.Rating, &returnedFilm.Description, &returnedFilm.Status)
	if err != nil {
		return nil, fmt.Errorf("db: query: %w", err)
	}

	return &returnedFilm, nil
}

func (fr *FilmRepository) UpdateFilm(film *domain.RequestFilmModel) (*domain.ResponseFilmModel, error) {
	var (
		returnedFilm domain.ResponseFilmModel
	)

	err := fr.db.QueryRow(`update film set user_id = $1, picture = $2, name = $3, rating = $4, description = $5, status = $6 where id = $7 and user_id = $8 returning user_id, id, picture, name, rating, description, status
      `, film.UserID, film.Picture, film.Name, film.Rating, film.Description, film.Status, film.ID, film.UserID).Scan(&returnedFilm.UserID, &returnedFilm.ID, &returnedFilm.Picture, &returnedFilm.Name, &returnedFilm.Rating, &returnedFilm.Description, &returnedFilm.Status)
	if err != nil {
		return nil, fmt.Errorf("db: query: %w", err)
	}

	return &returnedFilm, nil
}

func (fr *FilmRepository) GetFilmsByUserID(film *domain.RequestGetFilmsModel) ([]*domain.ResponseFilmModel, error) {
	var returnedFilms []*domain.ResponseFilmModel

	rows, err := fr.db.Query("select user_id, id, picture, name, rating, description, status from film where film.user_id = $1",
		film.UserID)
	if err != nil {
		return nil, fmt.Errorf("db: query: %w", err)
	}

	defer func(rows *sql.Rows) {
		cErr := rows.Close()
		if cErr != nil {
			if err != nil {
				err = cErr
			}

			err = errors.Join(err, cErr)
		}
	}(rows)

	for rows.Next() {
		var returnedFilm domain.ResponseFilmModel
		err = rows.Scan(&returnedFilm.UserID, &returnedFilm.ID, &returnedFilm.Picture, &returnedFilm.Name, &returnedFilm.Rating, &returnedFilm.Description, &returnedFilm.Status)
		if err != nil {
			return nil, fmt.Errorf("db: scan: %w", err)
		}

		returnedFilms = append(returnedFilms, &returnedFilm)
	}

	return returnedFilms, nil
}
