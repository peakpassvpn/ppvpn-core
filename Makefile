MOBILE_VERSION := v0.0.0-20260709172247-6129f5bee9d5
GO_BIN := $(shell go env GOPATH)/bin
CLANG_MODULE_CACHE_PATH ?= /tmp/jiluoyun-core-clang-cache
export PATH := $(GO_BIN):$(PATH)

.PHONY: test test-race build-desktop build-release-desktop bootstrap-mobile build-mobile-ios build-mobile-android

test:
	go test ./...

test-race:
	go test -race ./...

build-desktop:
	go build -trimpath -o build/jiluoyun-core ./cmd/jiluoyun-core

build-release-desktop:
	mkdir -p build
	GOOS=darwin GOARCH=arm64 go build -trimpath -o build/jiluoyun-core-darwin-arm64 ./cmd/jiluoyun-core
	GOOS=darwin GOARCH=amd64 go build -trimpath -o build/jiluoyun-core-darwin-amd64 ./cmd/jiluoyun-core
	GOOS=windows GOARCH=amd64 go build -trimpath -o build/jiluoyun-core-windows-amd64.exe ./cmd/jiluoyun-core

bootstrap-mobile:
	go install golang.org/x/mobile/cmd/gomobile@$(MOBILE_VERSION)
	go install golang.org/x/mobile/cmd/gobind@$(MOBILE_VERSION)
	$(GO_BIN)/gomobile init

build-mobile-ios:
	mkdir -p build
	CLANG_MODULE_CACHE_PATH=$(CLANG_MODULE_CACHE_PATH) $(GO_BIN)/gomobile bind -target=ios -o build/JiluoyunCore.xcframework ./mobile

build-mobile-android:
	mkdir -p build
	$(GO_BIN)/gomobile bind -target=android -androidapi 23 -o build/jiluoyun-core.aar ./mobile
