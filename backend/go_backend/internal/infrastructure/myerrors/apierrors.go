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
