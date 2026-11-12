/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        culinary: {
          bg: '#FAF8F5',
          card: '#FFFFFF',
          primary: '#1E392A',
          primaryLight: '#2D5A43',
          accent: '#E67E22',
          accentMuted: '#FFF8F0',
          border: '#EBE7DF',
          textMain: '#1A1C19',
          textMuted: '#71766F'
        }
      },
      borderRadius: {
        'squircle-sm': '12px',
        'squircle-md': '18px',
        'squircle-lg': '24px'
      },
      boxShadow: {
        'soft': '0 4px 20px -2px rgba(26, 28, 25, 0.05)',
        'elevated': '0 10px 30px -4px rgba(26, 28, 25, 0.08)'
      }
    },
  },
  plugins: [],
}
