// Package webengine exposes the Qt WebEngine functionality to QML content.
//
// Qt WebEngine is not available for the MinGW toolchain, so this package
// only builds where Qt ships it (Linux, macOS, MSVC-based setups).

//go:build !windows
// +build !windows

package webengine

// #cgo CPPFLAGS: -I./
// #cgo CXXFLAGS: -std=c++17 -pedantic-errors -Wall -fno-strict-aliasing
// #cgo LDFLAGS: -lstdc++
// #cgo pkg-config: Qt6WebEngineQuick
//
// #include "webengine.h"
import "C"

import (
	"github.com/omegahd/qml"
)

// Initialize initializes the WebEngine extension.
//
// Since Qt 6, WebEngine must be initialized before the Qt application is
// created, so call Initialize from the main function before qml.Run.
// Calling it afterwards (inside the qml.Run function, as was common with
// Qt 5) is still attempted for compatibility, but Qt 6 logs a warning and
// WebEngine may not work in that case.
func Initialize() {
	if qml.Running() {
		qml.RunMain(func() {
			C.webengineInitialize()
		})
		return
	}
	C.webengineInitialize()
}
