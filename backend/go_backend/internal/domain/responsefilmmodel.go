package domain

type ResponseFilmModel struct {
	UserID      int     `json:"userID"`
	ID          int     `json:"id"`
	Picture     string  `json:"picture"`
	Name        string  `json:"name"`
	Rating      float32 `json:"rating"`
	Description string  `json:"description"`
	Status      int     `json:"status"`
}
