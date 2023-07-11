package main

import (
	"fmt"
	"os"

	heartbeat "github.com/ethereum-optimism/optimism/umi-heartbeat"
	"github.com/ethereum-optimism/optimism/umi-heartbeat/flags"
	oplog "github.com/ethereum-optimism/optimism/umi-service/log"
	"github.com/ethereum/go-ethereum/log"
	"github.com/urfave/cli"
)

var (
	Version   = ""
	GitCommit = ""
	GitDate   = ""
)

func main() {
	oplog.SetupDefaults()

	app := cli.NewApp()
	app.Flags = flags.Flags
	app.Version = fmt.Sprintf("%s-%s-%s", Version, GitCommit, GitDate)
	app.Name = "umi-heartbeat"
	app.Usage = "Heartbeat recorder"
	app.Description = "Service that records opt-in heartbeats from op nodes"
	app.Action = heartbeat.Main(app.Version)
	err := app.Run(os.Args)
	if err != nil {
		log.Crit("Application failed", "message", err)
	}
}
