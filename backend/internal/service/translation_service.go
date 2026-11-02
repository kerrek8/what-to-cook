package service

import (
	"errors"
	"fmt"
	"sync"

	"github.com/bregydoc/gtranslate"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"golang.org/x/text/language"
)

type TranslationService interface {
	Translate(request dto.TranslateRequest) (dto.TranslateResponse, error)
}

type translationService struct {
	mu    sync.Mutex
	cache map[string]string
}

func NewTranslationService() TranslationService {
	return &translationService{cache: make(map[string]string)}
}

func (s *translationService) Translate(request dto.TranslateRequest) (dto.TranslateResponse, error) {
	if request.Source == request.Target {
		return dto.TranslateResponse{Translations: request.Texts}, nil
	}

	result := dto.TranslateResponse{Translations: make([]string, len(request.Texts))}
	for index, text := range request.Texts {
		key := request.Source + ":" + request.Target + ":" + text

		s.mu.Lock()
		translated, ok := s.cache[key]
		if !ok {
			var err error
			translated, err = translateSafely(text, request.Source, request.Target)
			if err != nil {
				s.mu.Unlock()
				return dto.TranslateResponse{}, fmt.Errorf("translate text: %w", err)
			}
			if len(s.cache) >= 3000 {
				s.cache = make(map[string]string)
			}
			s.cache[key] = translated
		}
		s.mu.Unlock()

		if translated == "" && text != "" {
			return dto.TranslateResponse{}, errors.New("translation returned an empty result")
		}
		result.Translations[index] = translated
	}

	return result, nil
}

func translateSafely(text, source, target string) (translated string, err error) {
	defer func() {
		if recovered := recover(); recovered != nil {
			translated = ""
			err = fmt.Errorf("translation library panic: %v", recovered)
		}
	}()

	return gtranslate.Translate(text, language.Make(source), language.Make(target))
}
