package handler_test

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"image"
	"image/color"
	"image/jpeg"
	"mime/multipart"
	"net/http"
	"net/http/httptest"
	"net/textproto"
	"os"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/handler"
	"github.com/kerrek8/what-to-cook/backend/internal/middleware"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/kerrek8/what-to-cook/backend/internal/storage"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type mockUserQuerier struct {
	store.Querier
	users map[string]store.User
}

func newMockUserQuerier() *mockUserQuerier {
	return &mockUserQuerier{users: make(map[string]store.User)}
}

func (m *mockUserQuerier) GetUserByID(ctx context.Context, id pgtype.UUID) (store.User, error) {
	idStr := uuid.UUID(id.Bytes).String()
	u, ok := m.users[idStr]
	if !ok {
		return store.User{}, pgx.ErrNoRows
	}
	return u, nil
}

func (m *mockUserQuerier) UpdateUserExcludedIngredients(ctx context.Context, arg store.UpdateUserExcludedIngredientsParams) error {
	idStr := uuid.UUID(arg.ID.Bytes).String()
	u, ok := m.users[idStr]
	if !ok {
		return pgx.ErrNoRows
	}
	u.ExcludedIngredientIds = arg.ExcludedIngredientIds
	m.users[idStr] = u
	return nil
}

func (m *mockUserQuerier) UpdateUserAvatar(ctx context.Context, arg store.UpdateUserAvatarParams) (store.User, error) {
	idStr := uuid.UUID(arg.ID.Bytes).String()
	u, ok := m.users[idStr]
	if !ok {
		return store.User{}, pgx.ErrNoRows
	}
	u.AvatarUrl = arg.AvatarUrl
	m.users[idStr] = u
	return u, nil
}

func createTestJPEG(w, h int) []byte {
	img := image.NewRGBA(image.Rect(0, 0, w, h))
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			img.Set(x, y, color.RGBA{R: uint8(x % 256), G: uint8(y % 256), B: 128, A: 255})
		}
	}
	var buf bytes.Buffer
	_ = jpeg.Encode(&buf, img, &jpeg.Options{Quality: 80})
	return buf.Bytes()
}

func createMultipartRequest(url, fieldName, fileName, contentType string, fileData []byte) (*http.Request, error) {
	var body bytes.Buffer
	writer := multipart.NewWriter(&body)
	h := make(textproto.MIMEHeader)
	h.Set("Content-Disposition", fmt.Sprintf(`form-data; name="%s"; filename="%s"`, fieldName, fileName))
	h.Set("Content-Type", contentType)
	part, err := writer.CreatePart(h)
	if err != nil {
		return nil, err
	}
	if _, err := part.Write(fileData); err != nil {
		return nil, err
	}
	if err := writer.Close(); err != nil {
		return nil, err
	}
	req := httptest.NewRequest(http.MethodPost, url, &body)
	req.Header.Set("Content-Type", writer.FormDataContentType())
	return req, nil
}

func TestUserHandler(t *testing.T) {
	gin.SetMode(gin.TestMode)
	mock := newMockUserQuerier()
	userService := service.NewUserService(mock)

	tempDir, err := os.MkdirTemp("", "user_handler_test_*")
	require.NoError(t, err)
	defer os.RemoveAll(tempDir)

	mediaStore := storage.NewLocalStorage(tempDir, "/uploads")
	userHandler := handler.NewUserHandler(userService, mediaStore)

	testUserID := uuid.New()
	testUserIDStr := testUserID.String()
	mock.users[testUserIDStr] = store.User{
		ID:                    pgtype.UUID{Bytes: testUserID, Valid: true},
		Email:                 "me@example.com",
		Name:                  "Me User",
		TokenVersion:          1,
		ExcludedIngredientIds: []int32{},
		CreatedAt:             pgtype.Timestamptz{Time: time.Now(), Valid: true},
	}

	r := gin.New()
	r.Use(func(c *gin.Context) {
		c.Set(middleware.ContextUserIDKey, testUserIDStr)
		c.Next()
	})
	r.GET("/api/v1/users/me", userHandler.GetMe)
	r.PUT("/api/v1/users/me/allergens", userHandler.UpdateAllergens)
	r.POST("/api/v1/users/me/avatar", userHandler.UploadAvatar)
	r.DELETE("/api/v1/users/me/avatar", userHandler.DeleteAvatar)

	t.Run("get me success", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodGet, "/api/v1/users/me", nil)
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)

		var resp dto.UserResponse
		err := json.Unmarshal(w.Body.Bytes(), &resp)
		require.NoError(t, err)
		assert.Equal(t, "me@example.com", resp.Email)
		assert.Nil(t, resp.AvatarURL)
	})

	t.Run("update allergens success", func(t *testing.T) {
		body, _ := json.Marshal(dto.UpdateAllergensRequest{
			ExcludedIngredientIDs: []int32{15},
		})

		req := httptest.NewRequest(http.MethodPut, "/api/v1/users/me/allergens", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)

		var resp dto.UserResponse
		err := json.Unmarshal(w.Body.Bytes(), &resp)
		require.NoError(t, err)
		assert.Equal(t, []int32{15}, resp.ExcludedIngredientIDs)
	})

	t.Run("update allergens exceeds free limit fails with 400", func(t *testing.T) {
		body, _ := json.Marshal(dto.UpdateAllergensRequest{
			ExcludedIngredientIDs: []int32{15, 20},
		})

		req := httptest.NewRequest(http.MethodPut, "/api/v1/users/me/allergens", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusBadRequest, w.Code)
	})

	t.Run("upload avatar success", func(t *testing.T) {
		jpegBytes := createTestJPEG(300, 300)
		req, err := createMultipartRequest("/api/v1/users/me/avatar", "avatar", "avatar.jpg", "image/jpeg", jpegBytes)
		require.NoError(t, err)
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)

		var resp dto.UploadAvatarResponse
		err = json.Unmarshal(w.Body.Bytes(), &resp)
		require.NoError(t, err)
		expectedURL := fmt.Sprintf("/uploads/avatars/%s.jpg", testUserIDStr)
		assert.Equal(t, expectedURL, resp.AvatarURL)

		user := mock.users[testUserIDStr]
		assert.True(t, user.AvatarUrl.Valid)
		assert.Equal(t, expectedURL, user.AvatarUrl.String)
	})

	t.Run("upload avatar file too large fails with 400", func(t *testing.T) {
		oversized := make([]byte, 5*1024*1024+16)
		req, err := createMultipartRequest("/api/v1/users/me/avatar", "avatar", "large.jpg", "image/jpeg", oversized)
		require.NoError(t, err)
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusBadRequest, w.Code)
	})

	t.Run("upload avatar invalid MIME fails with 400", func(t *testing.T) {
		req, err := createMultipartRequest("/api/v1/users/me/avatar", "avatar", "doc.txt", "text/plain", []byte("plain text content"))
		require.NoError(t, err)
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusBadRequest, w.Code)
	})

	t.Run("upload avatar missing file fails with 400", func(t *testing.T) {
		req, err := createMultipartRequest("/api/v1/users/me/avatar", "not_avatar", "avatar.jpg", "image/jpeg", []byte("xyz"))
		require.NoError(t, err)
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusBadRequest, w.Code)
	})

	t.Run("delete avatar success", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodDelete, "/api/v1/users/me/avatar", nil)
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusNoContent, w.Code)

		user := mock.users[testUserIDStr]
		assert.False(t, user.AvatarUrl.Valid)
	})
}
