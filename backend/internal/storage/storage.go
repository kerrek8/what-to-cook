package storage

import (
	"bytes"
	"context"
	"errors"
	"fmt"
	"image"
	_ "image/jpeg"
	"image/jpeg"
	_ "image/png"
	"math"
	"os"
	"path/filepath"
	"strings"
)

type Storage interface {
	Save(ctx context.Context, relativePath string, data []byte) (string, error)
	GetURL(relativePath string) string
}

type LocalStorage struct {
	baseDir string
	baseURL string
}

func NewLocalStorage(baseDir, baseURL string) *LocalStorage {
	cleanDir := filepath.Clean(baseDir)
	cleanURL := strings.TrimRight(baseURL, "/")
	if cleanURL == "" {
		cleanURL = "/uploads"
	}
	return &LocalStorage{
		baseDir: cleanDir,
		baseURL: cleanURL,
	}
}

func (s *LocalStorage) Save(ctx context.Context, relativePath string, data []byte) (string, error) {
	cleanRel := filepath.Clean(filepath.ToSlash(relativePath))
	if strings.HasPrefix(cleanRel, "..") || strings.HasPrefix(cleanRel, "/") {
		return "", errors.New("invalid relative path")
	}

	fullPath := filepath.Join(s.baseDir, filepath.FromSlash(cleanRel))
	dir := filepath.Dir(fullPath)
	if err := os.MkdirAll(dir, 0755); err != nil {
		return "", fmt.Errorf("failed to create directory: %w", err)
	}

	if err := os.WriteFile(fullPath, data, 0644); err != nil {
		return "", fmt.Errorf("failed to write file: %w", err)
	}

	return s.GetURL(cleanRel), nil
}

func (s *LocalStorage) GetURL(relativePath string) string {
	cleanRel := strings.TrimLeft(filepath.ToSlash(relativePath), "/")
	return fmt.Sprintf("%s/%s", s.baseURL, cleanRel)
}

// OptimizeRecipeImage scales the image to 512x512 with bilinear interpolation
// and encodes to JPEG at 75 quality to minimize disk usage.
func OptimizeRecipeImage(raw []byte) ([]byte, error) {
	if len(raw) == 0 {
		return nil, errors.New("empty image data")
	}

	src, _, err := image.Decode(bytes.NewReader(raw))
	if err != nil {
		return nil, fmt.Errorf("failed to decode image: %w", err)
	}

	targetSize := 512
	resized := resizeBilinearSquare(src, targetSize)

	var buf bytes.Buffer
	if err := jpeg.Encode(&buf, resized, &jpeg.Options{Quality: 75}); err != nil {
		return nil, fmt.Errorf("failed to encode jpeg: %w", err)
	}

	return buf.Bytes(), nil
}

func resizeBilinearSquare(src image.Image, target int) *image.RGBA {
	bounds := src.Bounds()
	srcW := bounds.Dx()
	srcH := bounds.Dy()
	dst := image.NewRGBA(image.Rect(0, 0, target, target))

	xRatio := float64(srcW-1) / float64(target)
	yRatio := float64(srcH-1) / float64(target)

	for y := 0; y < target; y++ {
		srcY := float64(y) * yRatio
		yLow := int(math.Floor(srcY))
		yHigh := int(math.Ceil(srcY))
		yWeight := srcY - float64(yLow)

		for x := 0; x < target; x++ {
			srcX := float64(x) * xRatio
			xLow := int(math.Floor(srcX))
			xHigh := int(math.Ceil(srcX))
			xWeight := srcX - float64(xLow)

			c00 := src.At(bounds.Min.X+xLow, bounds.Min.Y+yLow)
			c10 := src.At(bounds.Min.X+xHigh, bounds.Min.Y+yLow)
			c01 := src.At(bounds.Min.X+xLow, bounds.Min.Y+yHigh)
			c11 := src.At(bounds.Min.X+xHigh, bounds.Min.Y+yHigh)

			r00, g00, b00, a00 := c00.RGBA()
			r10, g10, b10, a10 := c10.RGBA()
			r01, g01, b01, a01 := c01.RGBA()
			r11, g11, b11, a11 := c11.RGBA()

			topR := float64(r00)*(1-xWeight) + float64(r10)*xWeight
			topG := float64(g00)*(1-xWeight) + float64(g10)*xWeight
			topB := float64(b00)*(1-xWeight) + float64(b10)*xWeight
			topA := float64(a00)*(1-xWeight) + float64(a10)*xWeight

			botR := float64(r01)*(1-xWeight) + float64(r11)*xWeight
			botG := float64(g01)*(1-xWeight) + float64(g11)*xWeight
			botB := float64(b01)*(1-xWeight) + float64(b11)*xWeight
			botA := float64(a01)*(1-xWeight) + float64(a11)*xWeight

			finalR := uint8((topR*(1-yWeight) + botR*yWeight) / 257)
			finalG := uint8((topG*(1-yWeight) + botG*yWeight) / 257)
			finalB := uint8((topB*(1-yWeight) + botB*yWeight) / 257)
			finalA := uint8((topA*(1-yWeight) + botA*yWeight) / 257)

			offset := (y*target + x) * 4
			dst.Pix[offset] = finalR
			dst.Pix[offset+1] = finalG
			dst.Pix[offset+2] = finalB
			dst.Pix[offset+3] = finalA
		}
	}

	return dst
}
