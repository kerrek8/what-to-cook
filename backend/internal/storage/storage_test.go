package storage

import (
	"bytes"
	"context"
	"image"
	"image/color"
	"image/jpeg"
	"image/png"
	"os"
	"path/filepath"
	"strings"
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

func TestLocalStorage_Delete(t *testing.T) {
	tempDir, err := os.MkdirTemp("", "whatcook_storage_test_*")
	require.NoError(t, err)
	defer os.RemoveAll(tempDir)

	store := NewLocalStorage(tempDir, "/uploads")
	ctx := context.Background()

	data := []byte("test avatar data")
	_, err = store.Save(ctx, "avatars/user-123.jpg", data)
	require.NoError(t, err)

	filePath := filepath.Join(tempDir, "avatars", "user-123.jpg")
	_, err = os.Stat(filePath)
	require.NoError(t, err)

	err = store.Delete(ctx, "avatars/user-123.jpg")
	require.NoError(t, err)

	_, err = os.Stat(filePath)
	assert.True(t, os.IsNotExist(err))

	// Deleting already deleted or non-existent file succeeds
	err = store.Delete(ctx, "avatars/user-123.jpg")
	assert.NoError(t, err)

	// Test path traversal rejection
	err = store.Delete(ctx, "../sneaky.jpg")
	assert.Error(t, err)
}

func TestOptimizeAvatarImage_SquareJPEG(t *testing.T) {
	src := image.NewRGBA(image.Rect(0, 0, 600, 600))
	for y := 0; y < 600; y++ {
		for x := 0; x < 600; x++ {
			src.Set(x, y, color.RGBA{R: uint8(x % 256), G: uint8(y % 256), B: 150, A: 255})
		}
	}

	var buf bytes.Buffer
	err := jpeg.Encode(&buf, src, &jpeg.Options{Quality: 90})
	require.NoError(t, err)

	optimized, err := OptimizeAvatarImage(&buf)
	require.NoError(t, err)
	assert.NotEmpty(t, optimized)

	dec, format, err := image.Decode(bytes.NewReader(optimized))
	require.NoError(t, err)
	assert.Equal(t, "jpeg", format)
	assert.Equal(t, 256, dec.Bounds().Dx())
	assert.Equal(t, 256, dec.Bounds().Dy())
}

func TestOptimizeAvatarImage_RectangularPNG(t *testing.T) {
	src := image.NewRGBA(image.Rect(0, 0, 800, 400))
	for y := 0; y < 400; y++ {
		for x := 0; x < 800; x++ {
			src.Set(x, y, color.RGBA{R: 200, G: uint8(y % 256), B: uint8(x % 256), A: 255})
		}
	}

	var buf bytes.Buffer
	err := png.Encode(&buf, src)
	require.NoError(t, err)

	optimized, err := OptimizeAvatarImage(&buf)
	require.NoError(t, err)
	assert.NotEmpty(t, optimized)

	dec, format, err := image.Decode(bytes.NewReader(optimized))
	require.NoError(t, err)
	assert.Equal(t, "jpeg", format)
	assert.Equal(t, 256, dec.Bounds().Dx())
	assert.Equal(t, 256, dec.Bounds().Dy())
}

func TestOptimizeAvatarImage_Errors(t *testing.T) {
	t.Run("nil reader", func(t *testing.T) {
		_, err := OptimizeAvatarImage(nil)
		assert.Error(t, err)
	})

	t.Run("corrupted bytes", func(t *testing.T) {
		_, err := OptimizeAvatarImage(strings.NewReader("not an image"))
		assert.Error(t, err)
	})
}

func TestOptimizeRecipeImage(t *testing.T) {
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

	dec, _, err := image.Decode(bytes.NewReader(optimized))
	require.NoError(t, err)
	assert.Equal(t, 512, dec.Bounds().Dx())
	assert.Equal(t, 512, dec.Bounds().Dy())
}

func TestOptimizeRecipeImage_EmptyData(t *testing.T) {
	_, err := OptimizeRecipeImage(nil)
	assert.Error(t, err)
}
