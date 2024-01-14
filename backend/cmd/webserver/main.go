package main

import (
	"github.com/diogoaguiar/diogoaguiar.pt/internal/webserver"
	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()

	webserver.InitRoutes(e)

	e.Logger.Fatal(e.Start(":8080"))
}
