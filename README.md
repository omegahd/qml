# QML support for the Go language (Qt 6)

This package provides Go bindings for QML: it lets Go applications drive
Qt Quick user interfaces, expose Go values and methods to QML, render
custom OpenGL content, and pack QML resources into the built binary.

This fork is a port of the binding to **Qt 6**.


Qt 6 verification status
------------------------

What follows is what has actually been *exercised* against **Qt 6.11.1 / MinGW
13.1 on Windows**, by driving a real Go + QML application (a car head unit) end
to end through this binding — not merely compiled. Entries marked "not tested"
are untried, not known-broken.

| Element | Status | Migrating from Qt 5 |
|---|---|---|
| `qml.Run`, `NewEngine`, `Engine.Context().SetVar` | ✅ working | Unchanged. |
| `Component.CreateWindow`, `Window.Root` / `Show` / `Wait` | ✅ working | Unchanged. |
| `Object.Set` / `Call` / `Int` / `Object` / `On`, `qml.Changed` | ✅ working | API unchanged — but the **names you pass** are Qt 6's. See the next table. |
| `genqrc` resource packing, `QRC_REPACK` | ✅ working | Must be regenerated: the generated file imports the binding by path, so a blob packed by `neclepsio/qml`'s genqrc will not build here. On Windows `genqrc.exe` links Qt 6 DLLs, so `go generate` fails with `0xc0000135` unless Qt's `bin` is on `PATH`. |
| `cdata` on `linux/arm64` | ⚠️ compiles only | `cdata/cdata14_arm64.s` had to be added; the fork shipped assembly for 386/amd64/arm only, so arm64 failed with `missing function body`. Compile-verified for arm64/arm/amd64/386, not yet run on hardware. |
| QtQuick, QtQml, Controls, Layouts, Window | ✅ working | Drop the version numbers. Qt 6 tolerates some `2.x` imports but not consistently; versionless is the idiom. |
| `QtMultimedia` — `MediaPlayer` + `AudioOutput` | ✅ working | `MediaPlayer.volume`/`autoLoad`/`autoPlay` are gone; volume moved to a separate `AudioOutput` child, and `autoPlay` becomes an explicit `play()`. Backend is ffmpeg from 6.5 on. |
| `QtPositioning` | ✅ working | Unchanged in use. |
| `QtLocation` — `Plugin`, `Map`, `MapQuickItem`, `MapPolyline` | ✅ working | QtLocation only returned in Qt **6.5**; it does not exist in 6.0–6.4. |
| `Map.tilt`, `Map.copyrightsVisible`, `Map.fitViewportToVisibleMapItems()`, `RouteQuery.setFeatureWeight()` | ✅ working | Unchanged — verified individually. |
| `Map.gesture` (`MapGestureArea`) | ❌ removed | The grouped `gesture` property is gone. Replacement is the new `MapView` type, which is itself just a `Map` plus `PinchHandler`/`DragHandler`/`WheelHandler` — Qt ships its source at `qml/QtLocation/MapView.qml` and invites copying it, which is the easy path if you cannot restructure an existing `Map`. |
| `mapboxgl` geoservices plugin | ❌ removed | Not in Qt 6; `Plugin.availableServiceProviders` offers only `osm` and `itemsoverlay` out of the box. Successor is MapLibre Native Qt, built separately — see below. |
| MapLibre Native Qt geoservices plugin | ✅ working | Builds clean with **MinGW** despite upstream CI being MSVC-only, using the compiler Qt ships (`Tools/mingw1310_64`) so the ABI matches. Renders a real vector style in-app. Parameters are `maplibre.map.styles` and `maplibre.cache.directory` (the mapboxgl names were `mapboxgl.mapping.additional_style_urls` / `.cache.directory`). |
| `QtGraphicalEffects` (`OpacityMask`) | ✅ working | Module renamed to `Qt5Compat.GraphicalEffects` — a drop-in. `QtQuick.Effects.MultiEffect` is the native Qt 6 alternative. |
| `QtQuick.VirtualKeyboard` (`InputPanel`) | ✅ resolves | Still present; `QT_IM_MODULE=qtvirtualkeyboard` still correct. Loaded and instantiated, not driven by touch. |
| `QtQuick.Extras` (`CircularGauge`) | ❌ removed | Removed with no replacement, together with the Controls 1 styling system (`QtQuick.Controls.Styles`, `CircularGaugeStyle`) it depended on. Must be reimplemented; if the old style was already `Canvas`-based, the paint code transfers almost verbatim once style and control are collapsed into one component. |
| `VideoOutput.source` | ❌ removed | Now `MediaPlayer.videoOutput = <the VideoOutput>`, i.e. wired from the player side. **Not yet tested here.** |
| `Camera` + `viewfinder` | ❌ removed | Replaced by `CaptureSession { camera: Camera { cameraDevice: … }; videoOutput: … }`, and `QtMultimedia.availableCameras` by `MediaDevices.videoInputs`. **Not yet tested here.** |
| OpenGL painting (`gl/*`, `Paint` methods) | ⬜ not tested | Not used by the test application. |
| `webengine` subpackage | ⬜ not tested | Excluded on Windows — Qt ships no WebEngine for MinGW. |

### Silent breakages the binding cannot catch

This package drives QML objects by **string** name, so these are unchecked at
compile time and fail — or worse, quietly misbehave — at runtime. Grep every
`Call(`, `Set(`, `Int(` and `On(` in your code and check each name against the
Qt 6 API. All of these were hit in a single source file:

| Qt 5 | Qt 6 | Symptom if missed |
|---|---|---|
| `Call("seek", pos)` | `Set("position", pos)` | Hard panic: `object does not expose a method "seek"`. |
| `Int("status")` | `Int("mediaStatus")` | Property renamed; reads fail. |
| `status == 7` / `== 8` | `== 6` / `== 7` | **Silent.** Qt 5's MediaStatus led with `UnknownMediaStatus = 0`, which Qt 6 dropped — every value shifted down by one. Playback stopped at end-of-track instead of advancing, with no error anywhere. |

`Call("play"/"pause"/"stop")`, `Int("position"/"duration"/"playbackState")` and
`On("playbackStateChanged", …)` are unchanged, and `playbackState`'s enum values
(Stopped=0, Playing=1, Paused=2) did not move.


Credits and lineage
-------------------

  * The original [go-qml/qml](https://github.com/go-qml/qml) package was written
    by Gustavo Niemeyer. All the fundamental design — the engine/context/value
    model, the dynamic meta object bridge, the OpenGL painting API, and the
    resource packing tooling — is his work, as are the blog posts and videos
    linked below.
  * [neclepsio/qml](https://github.com/neclepsio/qml) kept the package working
    after upstream development stopped, adding support for Qt 5.11+ and
    Go 1.12, and collecting fixes and features from several other forks of
    go-qml. In neclepsio's own words: some of those were copied and pasted, so
    the original author of a commit is sometimes lost (sorry!).
  * This repository ([omegahd/qml](https://github.com/omegahd/qml)) continues
    from neclepsio/qml and ports the whole package — core binding, OpenGL
    bindings, webengine and the examples — to Qt 6.


What changed in the Qt 6 port
-----------------------------

  * Builds against Qt 6 (`Qt6Core`, `Qt6Widgets`, `Qt6Quick` via `pkg-config`)
    with a C++17 compiler. Developed and tested against Qt 6.11 / MinGW 13.1
    on Windows.
  * The scene graph is forced to the OpenGL backend (instead of the Qt 6 RHI
    default) so the OpenGL painting APIs (`gl/*` packages and `Paint` methods)
    keep working. Painted items are rendered through
    `QQuickFramebufferObject`, as `QQuickPaintedItem` is raster-only in Qt 6.
  * More Go/QML value conversions: `time.Time` ↔ QML `date`, `[]byte` ↔
    `QByteArray`, `qml.Rect`/`qml.Point`/`qml.Size` ↔ QML `rect`/`point`/`size`,
    arbitrary Go slices and arrays are now delivered to QML as real JS
    arrays, and Go maps with string keys as JS objects (both recursively),
    instead of opaque wrappers.
  * New API: `SetWindowIcon`, and `Engine.AddImportPath`/`AddPluginPath`
    (plus `Clear*` variants) for loading external QML modules and plugins
    from custom locations.
  * The `webengine` subpackage wraps Qt6WebEngineQuick instead of the defunct
    QtWebKit. It is excluded on Windows, where Qt does not ship WebEngine for
    the MinGW toolchain; use it on Linux or macOS. Since Qt 6,
    `webengine.Initialize` must be called before `qml.Run`.
  * The examples were ported to Qt 6; the `controls` examples are rewritten
    with Qt Quick Controls 2, since Controls 1 was removed in Qt 6.
  * Test suites now run through `TestMain` wrapping `m.Run` in `qml.Run`
    (see `qml_test.go`); the old code-patching `SetupTesting` mechanism does
    not work on modern Go runtimes.


Installation
------------

Requirements:

  * Go >= 1.18
  * A Qt 6 installation with development files, **including the private
    headers** (the default Qt online installer layout includes them; on Linux
    distributions they typically come from a `qt6-base-private-dev` or
    similarly named package)
  * A C++17 compiler matching your Qt build (on Windows: the MinGW toolchain
    offered by the Qt installer)
  * `pkg-config`, with `PKG_CONFIG_PATH` pointing at Qt's `lib/pkgconfig`

Add the package to your module:

    go get github.com/omegahd/qml

then set up the build environment as described below and build. Building in
GOPATH mode (`GO111MODULE=off`) also still works.


Building against Qt 6
---------------------

Because the dynamic meta object support relies on Qt private headers whose
include paths embed the exact Qt version, `CGO_CPPFLAGS` must point into your
Qt installation. The `build-env.sh` script at the repository root derives
everything automatically — source it before building (optionally passing the
Qt prefix):

    . ./build-env.sh                            # auto-detect via qtpaths6/qmake6
    . ./build-env.sh C:/Qt6/6.11.1/mingw_64     # explicit prefix (Git Bash)
    go build .

Or set the environment manually. For example, on Windows with Qt 6.11.1
installed under `C:\Qt6` (Git Bash syntax):

    export QT=C:/Qt6/6.11.1/mingw_64
    export PATH="C:/Qt6/Tools/mingw1310_64/bin:$QT/bin:$PATH"
    export PKG_CONFIG_PATH=$QT/lib/pkgconfig
    export CGO_CPPFLAGS="-I$QT/include/QtCore/6.11.1 -I$QT/include/QtCore/6.11.1/QtCore"
    go build .

Adjust the version segment (`6.11.1`) to the Qt version you have installed.
The same recipe works on Linux; prefer a reasonably recent Qt 6 there, since
the pre-generated moc files in `cpp/` were produced by a current Qt 6 moc.


Documentation
-------------

The introductory documentation as well as the detailed API documentation of
the original package is available at
[gopkg.in/qml.v1](http://godoc.org/gopkg.in/qml.v1). The core API is
unchanged in this fork apart from the additions listed above; adjust import
paths to `github.com/omegahd/qml`.


Blog posts
----------

Posts by the original author about the package:

  * [Announcing qml v1 for Go](http://blog.labix.org/2014/08/13/announcing-qml-v1-for-go)
  * [Packing resources into Go qml binaries](http://blog.labix.org/2014/09/26/packing-resources-into-go-qml-binaries)
  * [Go qml contest results](http://blog.labix.org/2014/04/25/qml-contest-results)
  * [Arbitrary Qt extensions with Go qml](http://blog.labix.org/2014/03/21/arbitrary-qt-extensions-with-go-qml)
  * [The new Go qml OpenGL API](http://blog.labix.org/2014/08/29/the-new-go-qml-opengl-api)
  * [QML components with Go and OpenGL](http://blog.labix.org/2013/12/23/qml-components-with-go-and-opengl)


Videos
------

These introductory videos demonstrate the use of Go QML:

  * [Initial demo and overview](http://youtu.be/FVQlMrPa7lI)
  * [Initial demo running on an Ubuntu Touch phone](http://youtu.be/HB-3o8Cysec)
  * [Spinning Gopher with Go + QML + OpenGL](http://youtu.be/qkH7_dtOyPk)
  * [SameGame QML tutorial in Go](http://youtu.be/z8noX48hiMI)

