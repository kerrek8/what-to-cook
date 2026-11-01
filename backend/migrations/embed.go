package migrations

import "embed"

// Files contains the SQL migration scripts shipped with the API binary.
//
//go:embed *.sql
var Files embed.FS
