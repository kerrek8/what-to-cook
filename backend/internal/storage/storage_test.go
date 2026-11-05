package storage

import (
	"bytes"
	"context"
	"image"
	"image/color"
	"image/jpeg"
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestLocalStorage_SaveAndGetURL(t *testing.T) {
	tempDir, err := os.MkdirTemp("", "whatcook_storage_test_*")
	require.NoError(t, err)
	defer os.RemoveAll(tempDir)

	store := NewLocalStorage(tempDir, "/uploads")
	ctx := context.Background()

	data := []byte("test image data")
	url, err := store.Save(ctx, "recipes/test.jpg", data)
	require.NoError(t, err)
	assert.Equal(t, "/uploads/recipes/test.jpg", url)

	// Verify file on disk
	savedData, err := os.ReadFile(filepath.Join(tempDir, "recipes", "test.jpg"))
	require.NoError(t, err)
	assert.Equal(t, data, savedData)

	// Test path traversal rejection
	_, err = store.Save(ctx, "../sneaky.jpg", data)
	assert.Error(t, err)
}

func TestOptimizeRecipeImage(t *testing.T) {
	// Create an uncompressed 800x800 image
	src := image.NewRGBA(image.Rect(0, 0, 800, 800))
	for y := 0; y < 800; y++ {
		for x := 0; x < 800; x++ {
			src.Set(x, y, color.RGBA{R: uint8(x % 256), G: uint8(y % 256), B: 100, A: 255})
		}
	}

	var buf bytes.Buffer
	err := jpeg.Encode(&buf, src, &jpeg.Options{Quality: 100})
	require.NoError(t, err)
	origBytes := buf.Bytes()

	optimized, err := OptimizeRecipeImage(origBytes)
	require.NoError(t, err)
	assert.NotEmpty(t, optimized)
	assert.Less(t, len(optimized), len(origBytes))

	// Verify optimized dimensions
	dec, _, err := image.Decode(bytes.NewReader(optimized))
	require.NoError(t, err)
	assert.Equal(t, 512, dec.Bounds().Dx())
	assert.Equal(t, 512, dec.Bounds().Dy())
}

func TestOptimizeRecipeImage_EmptyData(t *testing.T) {
	_, err := OptimizeRecipeImage(nil)
	assert.Error(t, err)
}
