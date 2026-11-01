package database

import (
	"errors"
	"fmt"
	"io/fs"

	"github.com/golang-migrate/migrate/v4"
	_ "github.com/golang-migrate/migrate/v4/database/postgres"
	"github.com/golang-migrate/migrate/v4/source/iofs"
)

func RunMigrations(databaseURL string, files fs.FS) error {
	source, err := iofs.New(files, ".")
	if err != nil {
		return fmt.Errorf("create migration source: %w", err)
	}
	migrator, err := migrate.NewWithSourceInstance("iofs", source, databaseURL)
	if err != nil {
		return fmt.Errorf("initialize migrations: %w", err)
	}
	defer migrator.Close()
	if err := migrator.Up(); err != nil && !errors.Is(err, migrate.ErrNoChange) {
		return fmt.Errorf("apply migrations: %w", err)
	}
	return nil
}
