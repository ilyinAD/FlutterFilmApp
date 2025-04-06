package domain

type RequestGetUnionModel struct {
	UserID          int      `json:"user_id"`
	ID              int      `json:"id"`
	Picture         string   `json:"picture"`
	Name            string   `json:"name"`
	Rating          float32  `json:"rating"`
	Description     string   `json:"description"`
	Status          int      `json:"status"`
	UserDescription string   `json:"user_description"`
	UserRating      *float64 `json:"user_rating"`
	FilmURL         string   `json:"film_url"`
	AddedAt         string   `json:"added_at"`
	ViewedAt        string   `json:"viewed_at"`
}
