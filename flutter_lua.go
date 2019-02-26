/* This is free and unencumbered software released into the public domain. */

// Package flutter_lua
package flutter_lua

import (
	"fmt"
	lua "github.com/Shopify/go-lua"
)

// State
type State struct {
	s *lua.State
}

// NewState
func NewState() *State {
	return &State{s: lua.NewState()}
}

// Version
func Version() string {
	state := lua.NewState()
	version := int(*lua.Version(state))
	return fmt.Sprintf("%d.%d", version/100, version%100)
}

// DoString
func (state *State) DoString(code string) error {
	return lua.DoString(state.s, code)
}
