package main

import (
	"fmt"
	"os"

	"github.com/omegahd/qml"
	"github.com/omegahd/qml/webengine"
)

func main() {
	// Since Qt 6 the web engine must be initialized before the Qt
	// application is created, so this must precede qml.Run.
	webengine.Initialize()

	fmt.Println(qml.Run(func() error {
		engine := qml.NewEngine()
		engine.On("quit", func() { os.Exit(0) })

		component, err := engine.LoadFile("webengine.qml")
		if err != nil {
			return err
		}
		win := component.CreateWindow(nil)
		win.Show()
		win.Wait()
		return nil
	}))
}
