package main

import (
	"go_backend/internal/infrastructure"
	"go_backend/internal/infrastructure/handlers"
	"go_backend/internal/infrastructure/repository"
	"go_backend/internal/infrastructure/usecases"

	_ "github.com/lib/pq"
	"go.uber.org/fx"
)

func main() {
	appOpts := fx.Options(
		fx.Provide(infrastructure.NewEngine),
		fx.Provide(handlers.NewHandlers),
		fx.Provide(handlers.NewUserHandler),
		fx.Provide(handlers.NewFilmHandler),
		fx.Provide(usecases.NewUserUseCase),
		fx.Provide(usecases.NewFilmUseCases),
		fx.Provide(repository.NewUserRepository),
		fx.Provide(repository.NewFilmRepository),
		fx.Provide(repository.NewUserFilmInfoRepository),
		fx.Provide(infrastructure.InitDB),
		fx.Invoke(infrastructure.StartServer),
	)
	fx.New(appOpts).Run()
}
