package main

import (
	"github.com/ethereum-optimism/optimism/umi-program/client"
	oplog "github.com/ethereum-optimism/optimism/umi-service/log"
)

func main() {
	// Default to a machine parsable but relatively human friendly log format.
	// Don't do anything fancy to detect if color output is supported.
	logger := oplog.NewLogger(oplog.CLIConfig{
		Level:  "info",
		Format: "logfmt",
		Color:  false,
	})
	client.Main(logger)
}
