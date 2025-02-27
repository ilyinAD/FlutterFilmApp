package handlers

type Handlers struct {
	UserHandler *UserHandler
	FilmHandler *FilmHandler
}

func NewHandlers(userHandler *UserHandler, filmHandler *FilmHandler) *Handlers {
	return &Handlers{
		UserHandler: userHandler,
		FilmHandler: filmHandler,
	}
}
