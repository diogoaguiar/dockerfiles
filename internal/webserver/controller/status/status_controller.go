package status_controller

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

func GetStatus(c echo.Context) error {
	return c.String(http.StatusOK, "OK")
}
