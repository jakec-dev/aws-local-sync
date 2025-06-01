package main

import "fmt"

var (
	Version   = "dev"
	GitCommit = "none"
	BuildTime = "unknown"
)

func main() {
	fmt.Printf("Version:\t%s\n", Version)
	fmt.Printf("Commit sha:\t%s\n", GitCommit)
	fmt.Printf("Built at:\t%s\n", BuildTime)
}
