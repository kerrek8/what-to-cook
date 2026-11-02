export function displayText(text: string | null | undefined): string {
  return text ?? ''
}

export function displayIngredientName(name: string, _nameEn?: string | null): string {
  return name
}

export function displayUnit(unit: string | null | undefined): string {
  return unit ?? ''
}
