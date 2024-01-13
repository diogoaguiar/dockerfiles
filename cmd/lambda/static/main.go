package main

import (
	"bufio"
	"fmt"
	"io"
	"os"

	"github.com/russross/blackfriday/v2"
)

const (
	articlesDir = "articles"
)

func main() {
	contents := readFile("articles/wood.md")

	output := blackfriday.Run(contents)

	fmt.Println(string(output))
}

func readFile(path string) []byte {
	file, err := os.Open(path)
	if err != nil {
		panic(err)
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
	return contents
}
