package domain

type RequestDeleteFilmModel struct {
	ID     int `json:"id"`
	UserID int `json:"user_id"`
}
