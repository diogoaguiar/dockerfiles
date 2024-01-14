package home_controller

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

func GetHome(c echo.Context) error {
	return c.HTML(http.StatusOK, "<h1>Hello!</h1>")
}
