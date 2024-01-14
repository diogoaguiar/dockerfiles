BINARY_NAME=webserver

.PHONY: build run debug

# Command to build the binary
build:
	go build -o ${BINARY_NAME} cmd/webserver/main.go

# Command to run the server normally
run: build
	./${BINARY_NAME}

# Command to run the server with Delve for debugging
debug: build
	dlv --listen=:2345 --headless=true --api-version=2 --accept-multiclient exec ./${BINARY_NAME}
