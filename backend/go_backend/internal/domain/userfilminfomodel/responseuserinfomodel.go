package userfilminfomodel

type ResponseUserFilmInfoModel struct {
	UserID          int      `json:"user_id"`
	FilmID          int      `json:"film_id"`
	UserDescription string   `json:"user_description"`
	UserRating      *float64 `json:"user_rating"`
	AddedAt         string   `json:"added_at"`
	ViewedAt        string   `json:"viewed_at"`
	Status          int      `json:"status"`
}
