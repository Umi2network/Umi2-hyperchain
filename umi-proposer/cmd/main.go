package main

import (
	"fmt"
	"os"

	"github.com/urfave/cli"

	"github.com/ethereum-optimism/optimism/umi-proposer/cmd/doc"
	"github.com/ethereum-optimism/optimism/umi-proposer/flags"
	"github.com/ethereum-optimism/optimism/umi-proposer/proposer"
	oplog "github.com/ethereum-optimism/optimism/umi-service/log"
	"github.com/ethereum/go-ethereum/log"
)

var (
	Version   = "v0.10.14"
	GitCommit = ""
	GitDate   = ""
)

func main() {
	oplog.SetupDefaults()

	app := cli.NewApp()
	app.Flags = flags.Flags
	app.Version = fmt.Sprintf("%s-%s-%s", Version, GitCommit, GitDate)
	app.Name = "umi-proposer"
	app.Usage = "L2Output Submitter"
	app.Description = "Service for generating and submitting L2 Output checkpoints to the L2OutputOracle contract"
	app.Action = curryMain(Version)
	app.Commands = []cli.Command{
		{
			Name:        "doc",
			Subcommands: doc.Subcommands,
		},
	}

	err := app.Run(os.Args)
	if err != nil {
		log.Crit("Application failed", "message", err)
	}
}

// curryMain transforms the proposer.Main function into an app.Action
// This is done to capture the Version of the proposer.
func curryMain(version string) func(ctx *cli.Context) error {
	return func(ctx *cli.Context) error {
		return proposer.Main(version, ctx)
	}
}
