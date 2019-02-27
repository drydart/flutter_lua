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
	return &State{s: lua.NewStateEx()}
}

// Version
func Version() string {
	state := lua.NewState()
	version := int(*lua.Version(state))
	return fmt.Sprintf("%d.%d", version/100, version%100)
}

// DoFile
func (state *State) DoFile(path string) error {
	return lua.DoFile(state.s, path)
}

// DoString
func (state *State) DoString(code string) error {
	return lua.DoString(state.s, code)
}

// HasResult
func (state *State) HasResult() bool {
	return state.s.Top() > 0
}

// ResultType
func (state *State) ResultType() int {
	return int(state.s.TypeOf(1))
}

// BoolValue
func (state *State) BoolValue() bool {
	return state.s.ToBoolean(1)
}

// IntValue
func (state *State) IntValue() int {
	value, _ := state.s.ToInteger(1)
	return value
}

// LongValue
func (state *State) LongValue() int {
	value, _ := state.s.ToInteger(1)
	return value
}

// DoubleValue
func (state *State) DoubleValue() float64 {
	value, _ := state.s.ToNumber(1)
	return value
}

// StringValue
func (state *State) StringValue() string {
	value, _ := state.s.ToString(1)
	return value
}
