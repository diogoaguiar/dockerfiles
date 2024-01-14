package article_controller

import (
	"bufio"
	"io"
	"net/http"
	"os"

	"github.com/labstack/echo/v4"
	"github.com/russross/blackfriday/v2"
)

const (
	articlesDir = "articles"
)

func GetArticle(c echo.Context) error {
	article := c.Param("article")

	if !articleExists(article) {
		return c.String(http.StatusNotFound, "Article not found")
	}

	contents, err := readFile(getArticlePath(article))
	if err != nil {
		return err
	}

	output := blackfriday.Run(contents)

	return c.HTML(http.StatusOK, string(output))
}

func articleExists(article string) bool {
	_, err := os.Stat(getArticlePath(article))
	return err == nil
}

func getArticlePath(article string) string {
	return articlesDir + "/" + article + ".md"
}

func readFile(path string) ([]byte, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	reader := bufio.NewReader(file)

	var contents []byte
	for {
		line, _, err := reader.ReadLine()
		if err == io.EOF {
			break
		}

		contents = append(contents, append(line, '\n')...)
	}

	return contents, nil
}
