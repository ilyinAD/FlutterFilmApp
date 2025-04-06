package userfilminfomodel

type RequestGetUserInfoModel struct {
	UserID int `json:"user_id"`
	FilmID int `json:"id"`
}
