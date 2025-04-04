package myerrors

import "fmt"

type ErrNoUser struct {
	Msg string
}

func (e ErrNoUser) Error() string {
	return fmt.Sprintf("user not found: %s", e.Msg)
}

type ErrWrongPass struct {
	Msg string
}

func (e ErrWrongPass) Error() string {
	return fmt.Sprintf("Wrong password for user: %s", e.Msg)
}

type ErrWrongPassOrNoUser struct {
}

func (e ErrWrongPassOrNoUser) Error() string {
	return fmt.Sprintf("Wrong password or wrong login")
}

type ErrExists struct {
	Msg string
}

func (e ErrExists) Error() string {
	return fmt.Sprintf("this %s already exists", e.Msg)
}
