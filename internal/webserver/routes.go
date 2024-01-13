package webserver

import (
	article_controller "github.com/diogoaguiar/diogoaguiar.pt/internal/webserver/controller/article"
	status_controller "github.com/diogoaguiar/diogoaguiar.pt/internal/webserver/controller/status"
	"github.com/labstack/echo/v4"
)

var (
	echoInstance *echo.Echo
)

type Method string

const (
	GET    Method = "GET"
	POST   Method = "POST"
	PUT    Method = "PUT"
	DELETE Method = "DELETE"
)

func InitRoutes(e *echo.Echo) {
	echoInstance = e
	registerRoutes()
	registerStaticFiles()
}

func registerRoutes() {
	route(GET, "/status", status_controller.GetStatus)
	route(GET, "articles/:article", article_controller.GetArticle)
}

func registerStaticFiles() {
	echoInstance.Static("/assets/*", "assets")
}

func route(method Method, path string, handlerFunc echo.HandlerFunc) {
	switch method {
	case GET:
		echoInstance.GET(path, handlerFunc)
	case POST:
		echoInstance.POST(path, handlerFunc)
	case PUT:
		echoInstance.PUT(path, handlerFunc)
	case DELETE:
		echoInstance.DELETE(path, handlerFunc)
	}
}
