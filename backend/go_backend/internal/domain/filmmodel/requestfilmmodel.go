package filmmodel

type RequestFilmModel struct {
	ID          int     `json:"id"`
	Picture     string  `json:"picture"`
	Name        string  `json:"name"`
	Rating      float32 `json:"rating"`
	Description string  `json:"description"`
	FilmURL     string  `json:"film_url"`
}
