package op_e2e

import (
	"context"
	"os"
	"os/exec"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
)

// BuildOpProgramClient builds the `umi-program` client executable and returns the path to the resulting executable
func BuildOpProgramClient(t *testing.T) string {
	t.Log("Building umi-program-client")
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Minute)
	defer cancel()
	cmd := exec.CommandContext(ctx, "make", "umi-program-client")
	cmd.Dir = "../umi-program"
	cmd.Stdout = os.Stdout // for debugging
	cmd.Stderr = os.Stderr // for debugging
	require.NoError(t, cmd.Run(), "Failed to build umi-program-client")
	t.Log("Built umi-program-client successfully")
	return "../umi-program/bin/umi-program-client"
}
